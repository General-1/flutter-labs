import 'package:equatable/equatable.dart';

import 'doctor.dart';

/// Tot ce afișează Homescreen-ul (secțiunea `homeScreen` din JSON).
class HomeFeed extends Equatable {
  const HomeFeed({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

  factory HomeFeed.fromJson(Map<String, dynamic> json) => HomeFeed(
    user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    hasUnreadNotifications:
        (json['notifications'] as Map<String, dynamic>)['hasUnread'] as bool,
    searchHint: (json['search'] as Map<String, dynamic>)['hint'] as String,
    appointment: UpcomingAppointment.fromJson(
      json['appointment'] as Map<String, dynamic>,
    ),
    healthServices: [
      for (final item in json['healthServices'] as List<dynamic>)
        HealthService.fromJson(item as Map<String, dynamic>),
    ],
    nearbyDoctors: [
      for (final item in json['nearbyDoctors'] as List<dynamic>)
        Doctor.fromJson(item as Map<String, dynamic>),
    ],
  );

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> healthServices;
  final List<Doctor> nearbyDoctors;

  @override
  List<Object?> get props => [
    user,
    hasUnreadNotifications,
    searchHint,
    appointment,
    healthServices,
    nearbyDoctors,
  ];
}

/// Utilizatorul din antet („Hi, Jonathan”).
class UserProfile extends Equatable {
  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    greeting: json['greeting'] as String,
    subtitle: json['subtitle'] as String,
    avatarUrl: json['avatarUrl'] as String,
  );

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  @override
  List<Object?> get props => [name, greeting, subtitle, avatarUrl];
}

/// Programarea afișată pe cardul turcoaz.
class UpcomingAppointment extends Equatable {
  const UpcomingAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) =>
      UpcomingAppointment(
        title: json['title'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
      );

  final String title;
  final String date;
  final String time;
  final Doctor doctor;

  @override
  List<Object?> get props => [title, date, time, doctor];
}

/// Un pătrățel din „Health Services”.
class HealthService extends Equatable {
  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
    id: json['id'] as String,
    name: json['name'] as String,
    iconUrl: json['iconUrl'] as String,
  );

  final String id;
  final String name;
  final String iconUrl;

  @override
  List<Object?> get props => [id, name, iconUrl];
}
