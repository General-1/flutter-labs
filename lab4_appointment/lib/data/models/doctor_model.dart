import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/doctor.dart';

part 'doctor_model.g.dart';

/// Un doctor din răspunsul serverului. Doctorul de pe cardul „Appointment” nu
/// are `id`, `distance` și `isFavorite`, de aceea sunt opționale.
@JsonSerializable()
class DoctorModel {
  const DoctorModel({
    this.id,
    required this.name,
    required this.specialty,
    this.distance,
    this.avatarUrl,
    this.isFavorite,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  final String? id;
  final String name;
  final String specialty;
  final String? distance;
  final String? avatarUrl;
  final bool? isFavorite;

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  Doctor toEntity() => Doctor(
    id: id ?? '',
    name: name,
    specialty: specialty,
    distance: distance ?? '',
    avatarUrl: avatarUrl ?? '',
    isFavorite: isFavorite ?? false,
  );
}
