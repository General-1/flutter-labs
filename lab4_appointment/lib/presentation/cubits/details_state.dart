import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/booking.dart';

/// Stările ecranului de detalii.
sealed class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

final class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

final class DetailsError extends DetailsState {
  const DetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Detaliile sunt încărcate; reține ora și ziua alese și cererea de programare.
final class DetailsSuccess extends DetailsState {
  const DetailsSuccess({
    required this.details,
    this.selectedHourId,
    this.selectedDateId,
    this.booking = const BookingIdle(),
  });

  final AppointmentDetails details;
  final String? selectedHourId;
  final String? selectedDateId;
  final BookingStatus booking;

  Slot? get selectedHour => _find(details.workingHours.slots, selectedHourId);

  Slot? get selectedDate => _find(details.dates.slots, selectedDateId);

  bool get isSending => booking is BookingSending;

  /// Butonul e activ dacă datele o permit, s-au ales ora și ziua și nu se
  /// trimite deja o cerere.
  bool get canBook =>
      details.bookEnabled &&
      selectedHour != null &&
      selectedDate != null &&
      !isSending;

  static Slot? _find(List<Slot> slots, String? id) {
    for (final slot in slots) {
      if (slot.id == id) return slot;
    }
    return null;
  }

  DetailsSuccess copyWith({
    String? selectedHourId,
    String? selectedDateId,
    BookingStatus? booking,
  }) => DetailsSuccess(
    details: details,
    selectedHourId: selectedHourId ?? this.selectedHourId,
    selectedDateId: selectedDateId ?? this.selectedDateId,
    booking: booking ?? this.booking,
  );

  @override
  List<Object?> get props => [details, selectedHourId, selectedDateId, booking];
}

/// Starea cererii `POST` pentru programare.
sealed class BookingStatus extends Equatable {
  const BookingStatus();

  @override
  List<Object?> get props => [];
}

final class BookingIdle extends BookingStatus {
  const BookingIdle();
}

final class BookingSending extends BookingStatus {
  const BookingSending();
}

final class BookingSent extends BookingStatus {
  const BookingSent(this.booking, this.confirmation);

  final Booking booking;
  final BookingConfirmation confirmation;

  @override
  List<Object?> get props => [booking, confirmation];
}

final class BookingFailed extends BookingStatus {
  const BookingFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
