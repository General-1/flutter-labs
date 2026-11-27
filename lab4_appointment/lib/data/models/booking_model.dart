import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/booking.dart';

part 'booking_model.g.dart';

/// Corpul cererii `POST` (serializare: obiect Dart → JSON).
@JsonSerializable()
class BookingRequestModel {
  const BookingRequestModel({
    required this.doctorName,
    required this.date,
    required this.hour,
  });

  factory BookingRequestModel.fromEntity(Booking booking) =>
      BookingRequestModel(
        doctorName: booking.doctorName,
        date: booking.date,
        hour: booking.hour,
      );

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestModelFromJson(json);

  final String doctorName;
  final String date;
  final String hour;

  Map<String, dynamic> toJson() => _$BookingRequestModelToJson(this);
}

/// Răspunsul serverului (deserializare: JSON → obiect Dart).
@JsonSerializable()
class BookingResponseModel {
  const BookingResponseModel({required this.id});

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseModelFromJson(json);

  final int id;

  Map<String, dynamic> toJson() => _$BookingResponseModelToJson(this);

  BookingConfirmation toEntity() => BookingConfirmation(reference: id);
}
