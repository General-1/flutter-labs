import 'package:equatable/equatable.dart';

/// Programarea cerută de utilizator: doar doctorul, ziua și ora.
class Booking extends Equatable {
  const Booking({
    required this.doctorName,
    required this.date,
    required this.hour,
  });

  final String doctorName;
  final String date;
  final String hour;

  @override
  List<Object?> get props => [doctorName, date, hour];
}

/// Răspunsul serverului după trimiterea programării.
class BookingConfirmation extends Equatable {
  const BookingConfirmation({required this.reference});

  /// Numărul primit de la server.
  final int reference;

  @override
  List<Object?> get props => [reference];
}
