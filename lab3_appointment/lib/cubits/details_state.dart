import 'package:equatable/equatable.dart';

import '../models/appointment_details.dart';

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

/// Detaliile sunt încărcate; reține ora și ziua alese.
final class DetailsSuccess extends DetailsState {
  const DetailsSuccess({
    required this.details,
    this.selectedHourId,
    this.selectedDateId,
  });

  final AppointmentDetails details;
  final String? selectedHourId;
  final String? selectedDateId;

  Slot? get selectedHour => _find(details.workingHours.slots, selectedHourId);

  Slot? get selectedDate => _find(details.dates.slots, selectedDateId);

  /// Butonul e activ doar dacă datele o permit și s-au ales ora și ziua.
  bool get canBook =>
      details.bookEnabled && selectedHour != null && selectedDate != null;

  static Slot? _find(List<Slot> slots, String? id) {
    for (final slot in slots) {
      if (slot.id == id) return slot;
    }
    return null;
  }

  DetailsSuccess copyWith({String? selectedHourId, String? selectedDateId}) =>
      DetailsSuccess(
        details: details,
        selectedHourId: selectedHourId ?? this.selectedHourId,
        selectedDateId: selectedDateId ?? this.selectedDateId,
      );

  @override
  List<Object?> get props => [details, selectedHourId, selectedDateId];
}
