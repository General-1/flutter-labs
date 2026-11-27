import 'package:equatable/equatable.dart';

import 'doctor.dart';

/// Tot ce afișează Homescreen-ul.
class HomeFeed extends Equatable {
  const HomeFeed({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.healthServices,
    required this.nearbyDoctors,
  });

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

  final String id;
  final String name;
  final String iconUrl;

  @override
  List<Object?> get props => [id, name, iconUrl];
}
