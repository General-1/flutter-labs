import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/appointment_details.dart';

part 'appointment_details_model.g.dart';

/// Răspunsul `GET /feed/details`.
@JsonSerializable()
class AppointmentDetailsModel {
  const AppointmentDetailsModel({
    required this.title,
    required this.doctor,
    required this.payment,
    required this.details,
    required this.workingHours,
    required this.date,
    required this.actions,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDetailsModelFromJson(json);

  final String title;
  final DetailsDoctorModel doctor;
  final PaymentModel payment;
  final DescriptionModel details;
  final SlotSectionModel workingHours;
  final SlotSectionModel date;
  final DetailsActionsModel actions;

  Map<String, dynamic> toJson() => _$AppointmentDetailsModelToJson(this);

  AppointmentDetails toEntity() => AppointmentDetails(
    title: title,
    doctor: doctor.toEntity(),
    paymentLabel: payment.label,
    paymentFormatted: payment.formatted,
    aboutTitle: details.title,
    about: details.description,
    workingHours: workingHours.toEntity(),
    dates: date.toEntity(),
    bookLabel: actions.bookAppointment.label,
    bookEnabled: actions.bookAppointment.enabled,
  );
}

@JsonSerializable()
class DetailsDoctorModel {
  const DetailsDoctorModel({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    required this.actions,
  });

  factory DetailsDoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsDoctorModelFromJson(json);

  final String name;
  final String clinic;
  final String avatarUrl;
  final ContactActionsModel actions;

  Map<String, dynamic> toJson() => _$DetailsDoctorModelToJson(this);

  DetailsDoctor toEntity() => DetailsDoctor(
    name: name,
    clinic: clinic,
    avatarUrl: avatarUrl,
    canMessage: actions.message,
    canCall: actions.call,
    canVideoCall: actions.videoCall,
  );
}

@JsonSerializable()
class ContactActionsModel {
  const ContactActionsModel({
    required this.message,
    required this.call,
    required this.videoCall,
  });

  factory ContactActionsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactActionsModelFromJson(json);

  final bool message;
  final bool call;
  final bool videoCall;

  Map<String, dynamic> toJson() => _$ContactActionsModelToJson(this);
}

@JsonSerializable()
class PaymentModel {
  const PaymentModel({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  final String label;
  final double amount;
  final String currency;
  final String formatted;

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}

@JsonSerializable()
class DescriptionModel {
  const DescriptionModel({required this.title, required this.description});

  factory DescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$DescriptionModelFromJson(json);

  final String title;
  final String description;

  Map<String, dynamic> toJson() => _$DescriptionModelToJson(this);
}

@JsonSerializable()
class SlotSectionModel {
  const SlotSectionModel({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  factory SlotSectionModel.fromJson(Map<String, dynamic> json) =>
      _$SlotSectionModelFromJson(json);

  final String title;
  final bool showAll;
  final List<SlotModel> slots;

  Map<String, dynamic> toJson() => _$SlotSectionModelToJson(this);

  SlotSection toEntity() => SlotSection(
    title: title,
    showAll: showAll,
    slots: [for (final s in slots) s.toEntity()],
  );
}

@JsonSerializable()
class SlotModel {
  const SlotModel({
    required this.id,
    required this.label,
    this.selected = false,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) =>
      _$SlotModelFromJson(json);

  final String id;
  final String label;
  final bool selected;

  Map<String, dynamic> toJson() => _$SlotModelToJson(this);

  Slot toEntity() => Slot(id: id, label: label, selected: selected);
}

@JsonSerializable()
class DetailsActionsModel {
  const DetailsActionsModel({required this.bookAppointment});

  factory DetailsActionsModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsActionsModelFromJson(json);

  final BookButtonModel bookAppointment;

  Map<String, dynamic> toJson() => _$DetailsActionsModelToJson(this);
}

@JsonSerializable()
class BookButtonModel {
  const BookButtonModel({required this.label, required this.enabled});

  factory BookButtonModel.fromJson(Map<String, dynamic> json) =>
      _$BookButtonModelFromJson(json);

  final String label;
  final bool enabled;

  Map<String, dynamic> toJson() => _$BookButtonModelToJson(this);
}
