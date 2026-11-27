import 'package:equatable/equatable.dart';

/// Un doctor, așa cum vine din fișierul JSON.
///
/// Doctorul de pe cardul „Appointment” nu are `id`, `distance` și
/// `isFavorite` în date, de aceea aceste câmpuri sunt opționale.
class Doctor extends Equatable {
  const Doctor({
    this.id = '',
    required this.name,
    required this.specialty,
    this.avatarUrl = '',
    this.distance = '',
    this.isFavorite = false,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] as String? ?? '',
    name: json['name'] as String,
    specialty: json['specialty'] as String,
    avatarUrl: json['avatarUrl'] as String? ?? '',
    distance: json['distance'] as String? ?? '',
    isFavorite: json['isFavorite'] as bool? ?? false,
  );

  final String id;
  final String name;
  final String specialty;
  final String avatarUrl;

  /// Textul complet, ex. „950 Sigrid Port - 753M from you”.
  final String distance;

  /// Valoarea inițială din date; ce marchează utilizatorul se ține în Cubit.
  final bool isFavorite;

  /// Inițialele pentru avatarul de rezervă („Dr. Sonja Litel” → „SL”).
  String get initials => name
      .replaceFirst('Dr.', '')
      .trim()
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0])
      .join();

  /// Distanța în metri, extrasă din text („500M” → 500, „1.4KM” → 1400).
  /// `null` dacă textul nu conține o distanță.
  int? get distanceInMeters {
    final matches = RegExp(
      r'(\d+(?:\.\d+)?)\s*(km|m)\b',
      caseSensitive: false,
    ).allMatches(distance);
    if (matches.isEmpty) return null;
    final value = double.parse(matches.last.group(1)!);
    final isKm = matches.last.group(2)!.toLowerCase() == 'km';
    return (isKm ? value * 1000 : value).round();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    avatarUrl,
    distance,
    isFavorite,
  ];
}
