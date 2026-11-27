import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_feed.dart';
import 'doctor_model.dart';

part 'home_feed_model.g.dart';

/// Răspunsul `GET /feed`. Clasele au aceeași formă ca JSON-ul, iar `toEntity`
/// le transformă în obiectele folosite de aplicație.
@JsonSerializable()
class HomeFeedModel {
  const HomeFeedModel({
    required this.user,
    required this.notifications,
    required this.search,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedModelFromJson(json);

  final UserModel user;
  final NotificationsModel notifications;
  final SearchModel search;
  final UpcomingAppointmentModel appointment;
  final List<HealthServiceModel> healthServices;
  final List<DoctorModel> nearbyDoctors;

  Map<String, dynamic> toJson() => _$HomeFeedModelToJson(this);

  HomeFeed toEntity() => HomeFeed(
    user: user.toEntity(),
    hasUnreadNotifications: notifications.hasUnread,
    searchHint: search.hint,
    appointment: appointment.toEntity(),
    healthServices: [for (final s in healthServices) s.toEntity()],
    nearbyDoctors: [for (final d in nearbyDoctors) d.toEntity()],
  );
}

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserProfile toEntity() => UserProfile(
    name: name,
    greeting: greeting,
    subtitle: subtitle,
    avatarUrl: avatarUrl,
  );
}

@JsonSerializable()
class NotificationsModel {
  const NotificationsModel({required this.hasUnread});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  final bool hasUnread;

  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);
}

@JsonSerializable()
class SearchModel {
  const SearchModel({required this.hint});

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  final String hint;

  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}

@JsonSerializable()
class UpcomingAppointmentModel {
  const UpcomingAppointmentModel({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingAppointmentModelFromJson(json);

  final String title;
  final String date;
  final String time;
  final DoctorModel doctor;

  Map<String, dynamic> toJson() => _$UpcomingAppointmentModelToJson(this);

  UpcomingAppointment toEntity() => UpcomingAppointment(
    title: title,
    date: date,
    time: time,
    doctor: doctor.toEntity(),
  );
}

@JsonSerializable()
class HealthServiceModel {
  const HealthServiceModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthServiceModel.fromJson(Map<String, dynamic> json) =>
      _$HealthServiceModelFromJson(json);

  final String id;
  final String name;
  final String iconUrl;

  Map<String, dynamic> toJson() => _$HealthServiceModelToJson(this);

  HealthService toEntity() =>
      HealthService(id: id, name: name, iconUrl: iconUrl);
}
