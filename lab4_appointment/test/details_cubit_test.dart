import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_appointment/core/error/failure.dart';
import 'package:lab4_appointment/domain/entities/booking.dart';
import 'package:lab4_appointment/domain/usecases/book_appointment.dart';
import 'package:lab4_appointment/domain/usecases/get_appointment_details.dart';
import 'package:lab4_appointment/presentation/cubits/details_cubit.dart';
import 'package:lab4_appointment/presentation/cubits/details_state.dart';

import 'helpers.dart';

DetailsCubit build(FakeRepository repository) => DetailsCubit(
  getDetails: GetAppointmentDetails(repository),
  bookAppointment: BookAppointment(repository),
);

final loaded = DetailsSuccess(
  details: sampleDetails,
  selectedHourId: '11am',
  selectedDateId: 'sun-4',
);

const booking = Booking(
  doctorName: 'Dr. Test',
  date: 'Sun 4',
  hour: '11.00 AM',
);

void main() {
  blocTest<DetailsCubit, DetailsState>(
    'Loading → Success cu selecția inițială din date',
    build: () => build(FakeRepository()),
    act: (cubit) => cubit.load(),
    expect: () => [const DetailsLoading(), loaded],
  );

  blocTest<DetailsCubit, DetailsState>(
    'Loading → Error cu mesajul din Failure',
    build: () =>
        build(FakeRepository()..detailsError = const ServerFailure(500)),
    act: (cubit) => cubit.load(),
    expect: () => const [
      DetailsLoading(),
      DetailsError('The server returned an error (500).'),
    ],
    errors: () => [isA<ServerFailure>()],
  );

  test('alegerea altei ore și zile', () async {
    final cubit = build(FakeRepository());
    await cubit.load();

    cubit
      ..selectHour('12pm')
      ..selectDate('mon-5');

    final state = cubit.state as DetailsSuccess;
    expect(state.selectedHour?.label, '12.00 PM');
    expect(state.selectedDate?.label, 'Mon 5');
    expect(state.canBook, isTrue);
    await cubit.close();
  });

  blocTest<DetailsCubit, DetailsState>(
    'programare: Sending → Sent',
    build: () => build(FakeRepository()),
    seed: () => loaded,
    act: (cubit) => cubit.book('Dr. Test'),
    expect: () => [
      loaded.copyWith(booking: const BookingSending()),
      loaded.copyWith(
        booking: const BookingSent(
          booking,
          BookingConfirmation(reference: 101),
        ),
      ),
    ],
  );

  blocTest<DetailsCubit, DetailsState>(
    'programare: Sending → Failed',
    build: () => build(FakeRepository()..bookingError = const NetworkFailure()),
    seed: () => loaded,
    act: (cubit) => cubit.book('Dr. Test'),
    expect: () => [
      loaded.copyWith(booking: const BookingSending()),
      loaded.copyWith(
        booking: const BookingFailed(
          'Cannot reach the server. Check your internet connection.',
        ),
      ),
    ],
    errors: () => [isA<NetworkFailure>()],
  );

  test('un al doilea tap nu trimite încă o cerere', () async {
    final repository = FakeRepository(bookingGate: Completer<void>());
    final cubit = build(repository);
    await cubit.load();

    final first = cubit.book('Dr. Test');
    await cubit.book('Dr. Test');
    expect((cubit.state as DetailsSuccess).canBook, isFalse);
    expect(repository.sent, [booking]);

    repository.bookingGate!.complete();
    await first;
    expect((cubit.state as DetailsSuccess).canBook, isTrue);
    await cubit.close();
  });

  test('Back în timpul trimiterii nu produce erori', () async {
    final repository = FakeRepository(bookingGate: Completer<void>());
    final cubit = build(repository);
    await cubit.load();

    final sending = cubit.book('Dr. Test');
    await cubit.close();
    repository.bookingGate!.complete();

    await expectLater(sending, completes);
  });
}
