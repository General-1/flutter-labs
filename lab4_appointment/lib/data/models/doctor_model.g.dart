// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  specialty: json['specialty'] as String,
  distance: json['distance'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isFavorite: json['isFavorite'] as bool?,
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': instance.name,
      'specialty': instance.specialty,
      'distance': ?instance.distance,
      'avatarUrl': ?instance.avatarUrl,
      'isFavorite': ?instance.isFavorite,
    };
