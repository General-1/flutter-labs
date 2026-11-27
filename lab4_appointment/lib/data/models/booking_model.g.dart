// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequestModel _$BookingRequestModelFromJson(Map<String, dynamic> json) =>
    BookingRequestModel(
      doctorName: json['doctorName'] as String,
      date: json['date'] as String,
      hour: json['hour'] as String,
    );

Map<String, dynamic> _$BookingRequestModelToJson(
  BookingRequestModel instance,
) => <String, dynamic>{
  'doctorName': instance.doctorName,
  'date': instance.date,
  'hour': instance.hour,
};

BookingResponseModel _$BookingResponseModelFromJson(
  Map<String, dynamic> json,
) => BookingResponseModel(id: (json['id'] as num).toInt());

Map<String, dynamic> _$BookingResponseModelToJson(
  BookingResponseModel instance,
) => <String, dynamic>{'id': instance.id};
