import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/appointment_details.dart';
import '../models/home_feed.dart';

/// Contractul sursei de date. Cubit-urile cunosc doar această interfață, deci
/// sursa (fișier JSON acum, REST API mai târziu) poate fi înlocuită.
abstract class AppointmentRepository {
  Future<HomeFeed> loadHomeFeed();

  Future<AppointmentDetails> loadAppointmentDetails();
}

/// Citește asincron datele din fișierul JSON inclus în proiect.
class AssetAppointmentRepository implements AppointmentRepository {
  AssetAppointmentRepository({
    AssetBundle? bundle,
    this.assetPath = defaultAsset,
    this.delay = const Duration(milliseconds: 800),
  }) : _bundle = bundle ?? rootBundle;

  static const defaultAsset = 'assets/data/lab_v2.json';

  final AssetBundle _bundle;
  final String assetPath;

  /// Întârziere simulată, ca starea Loading să fie vizibilă (un fișier local
  /// se citește aproape instantaneu).
  final Duration delay;

  @override
  Future<HomeFeed> loadHomeFeed() async =>
      HomeFeed.fromJson(await _readSection('homeScreen'));

  @override
  Future<AppointmentDetails> loadAppointmentDetails() async =>
      AppointmentDetails.fromJson(await _readSection('appointmentDetails'));

  /// Așteaptă, citește fișierul, îl decodează și întoarce secțiunea cerută.
  /// Orice problemă (fișier lipsă, JSON greșit) ajunge la Cubit ca excepție.
  Future<Map<String, dynamic>> _readSection(String key) async {
    await Future<void>.delayed(delay);
    final text = await _bundle.loadString(assetPath);
    final json = jsonDecode(text) as Map<String, dynamic>;
    return json[key] as Map<String, dynamic>;
  }
}
