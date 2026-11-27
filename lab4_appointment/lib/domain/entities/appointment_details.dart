import 'package:equatable/equatable.dart';

/// Datele ecranului de detalii.
class AppointmentDetails extends Equatable {
  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.paymentLabel,
    required this.paymentFormatted,
    required this.aboutTitle,
    required this.about,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  final String title;
  final DetailsDoctor doctor;
  final String paymentLabel;
  final String paymentFormatted;
  final String aboutTitle;
  final String about;
  final SlotSection workingHours;
  final SlotSection dates;
  final String bookLabel;
  final bool bookEnabled;

  @override
  List<Object?> get props => [
    title,
    doctor,
    paymentLabel,
    paymentFormatted,
    aboutTitle,
    about,
    workingHours,
    dates,
    bookLabel,
    bookEnabled,
  ];
}

/// Doctorul din secțiunea de detalii și butoanele de contact permise.
class DetailsDoctor extends Equatable {
  const DetailsDoctor({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
  });

  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  @override
  List<Object?> get props => [
    name,
    clinic,
    avatarUrl,
    canMessage,
    canCall,
    canVideoCall,
  ];
}

/// O secțiune cu chip-uri: „Working Hours” sau „Date”.
class SlotSection extends Equatable {
  const SlotSection({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  final String title;
  final bool showAll;
  final List<Slot> slots;

  /// Chip-ul selectat la deschidere: cel marcat în date, altfel primul.
  Slot? get initialSlot {
    for (final slot in slots) {
      if (slot.selected) return slot;
    }
    return slots.isEmpty ? null : slots.first;
  }

  @override
  List<Object?> get props => [title, showAll, slots];
}

/// Un singur chip (o oră sau o zi).
class Slot extends Equatable {
  const Slot({required this.id, required this.label, this.selected = false});

  final String id;
  final String label;
  final bool selected;

  @override
  List<Object?> get props => [id, label, selected];
}
