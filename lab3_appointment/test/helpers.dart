import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lab3_appointment/data/appointment_repository.dart';
import 'package:lab3_appointment/models/appointment_details.dart';
import 'package:lab3_appointment/models/doctor.dart';
import 'package:lab3_appointment/models/home_feed.dart';

Map<String, dynamic> _section(String path, String key) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>)[key]
        as Map<String, dynamic>;

/// Datele reale din fișierul JSON al aplicației.
final sampleFeed = HomeFeed.fromJson(
  _section(AssetAppointmentRepository.defaultAsset, 'homeScreen'),
);
final emptyFeed = HomeFeed.fromJson(
  _section('assets/data/lab_v2_empty.json', 'homeScreen'),
);
final sampleDetails = AppointmentDetails.fromJson(
  _section(AssetAppointmentRepository.defaultAsset, 'appointmentDetails'),
);

/// Același feed, dar cu altă listă de doctori (pentru testele de sortare).
HomeFeed feedWith(List<Doctor> doctors) => HomeFeed(
  user: sampleFeed.user,
  hasUnreadNotifications: sampleFeed.hasUnreadNotifications,
  searchHint: sampleFeed.searchHint,
  appointment: sampleFeed.appointment,
  healthServices: sampleFeed.healthServices,
  nearbyDoctors: doctors,
);

/// Sursă de date falsă: poate eșua sau poate aștepta un semnal din test.
class FakeRepository implements AppointmentRepository {
  FakeRepository({HomeFeed? feed, this.details, this.gate})
    : feed = feed ?? sampleFeed;

  final HomeFeed feed;
  final AppointmentDetails? details;

  /// Cât timp nu e completat, încărcarea rămâne în curs.
  final Completer<void>? gate;

  bool failHome = false;
  bool failDetails = false;

  @override
  Future<HomeFeed> loadHomeFeed() async {
    await gate?.future;
    if (failHome) throw const FormatException('JSON greșit');
    return feed;
  }

  @override
  Future<AppointmentDetails> loadAppointmentDetails() async {
    await gate?.future;
    if (failDetails) throw const FormatException('JSON greșit');
    return details ?? sampleDetails;
  }
}
