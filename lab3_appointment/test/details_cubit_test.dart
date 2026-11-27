import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_appointment/cubits/details_cubit.dart';
import 'package:lab3_appointment/cubits/details_state.dart';

import 'helpers.dart';

void main() {
  blocTest<DetailsCubit, DetailsState>(
    'Loading → Success cu selecția inițială din date',
    build: () => DetailsCubit(FakeRepository()),
    act: (cubit) => cubit.load(),
    expect: () => [
      const DetailsLoading(),
      DetailsSuccess(
        details: sampleDetails,
        selectedHourId: '11am',
        selectedDateId: 'sun-4',
      ),
    ],
  );

  blocTest<DetailsCubit, DetailsState>(
    'Loading → Error',
    build: () => DetailsCubit(FakeRepository()..failDetails = true),
    act: (cubit) => cubit.load(),
    expect: () => const [
      DetailsLoading(),
      DetailsError('Could not load the details.'),
    ],
    errors: () => [isA<FormatException>()],
  );

  test('alegerea altei ore și zile', () async {
    final cubit = DetailsCubit(FakeRepository());
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
}
