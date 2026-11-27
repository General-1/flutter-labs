import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lab4_appointment/data/models/appointment_details_model.dart';
import 'package:lab4_appointment/data/models/home_feed_model.dart';
import 'package:lab4_appointment/domain/entities/appointment_details.dart';
import 'package:lab4_appointment/domain/entities/booking.dart';
import 'package:lab4_appointment/domain/entities/doctor.dart';
import 'package:lab4_appointment/domain/entities/home_feed.dart';
import 'package:lab4_appointment/domain/repositories/appointment_repository.dart';

/// Răspunsuri reale ale serverului, salvate pentru teste (fără internet).
const feedFixture = 'test/fixtures/feed.json';
const detailsFixture = 'test/fixtures/feed_details.json';

String readFixture(String path) => File(path).readAsStringSync();

Map<String, dynamic> fixtureJson(String path) =>
    jsonDecode(readFixture(path)) as Map<String, dynamic>;

final sampleFeed = HomeFeedModel.fromJson(fixtureJson(feedFixture)).toEntity();
final sampleDetails = AppointmentDetailsModel.fromJson(
  fixtureJson(detailsFixture),
).toEntity();

/// Același feed, dar cu altă listă de doctori (pentru Empty și sortare).
HomeFeed feedWith(List<Doctor> doctors) => HomeFeed(
  user: sampleFeed.user,
  hasUnreadNotifications: sampleFeed.hasUnreadNotifications,
  searchHint: sampleFeed.searchHint,
  appointment: sampleFeed.appointment,
  healthServices: sampleFeed.healthServices,
  nearbyDoctors: doctors,
);

final emptyFeed = feedWith(const []);

/// Repository fals: poate eșua sau poate aștepta un semnal din test.
class FakeRepository implements AppointmentRepository {
  FakeRepository({HomeFeed? feed, this.gate, this.bookingGate})
    : feed = feed ?? sampleFeed;

  final HomeFeed feed;

  /// Cât timp nu e completat, încărcarea rămâne în curs.
  final Completer<void>? gate;

  /// La fel, pentru trimiterea programării.
  final Completer<void>? bookingGate;

  /// Dacă nu sunt `null`, metoda corespunzătoare le aruncă.
  Exception? homeError;
  Exception? detailsError;
  Exception? bookingError;

  /// Programările primite, în ordine.
  final List<Booking> sent = [];

  @override
  Future<HomeFeed> getHomeFeed() async {
    await gate?.future;
    if (homeError case final error?) throw error;
    return feed;
  }

  @override
  Future<AppointmentDetails> getAppointmentDetails() async {
    await gate?.future;
    if (detailsError case final error?) throw error;
    return sampleDetails;
  }

  @override
  Future<BookingConfirmation> bookAppointment(Booking booking) async {
    sent.add(booking);
    await bookingGate?.future;
    if (bookingError case final error?) throw error;
    return const BookingConfirmation(reference: 101);
  }
}
