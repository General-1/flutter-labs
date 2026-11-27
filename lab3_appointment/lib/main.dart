import 'package:flutter/material.dart';

import 'app.dart';
import 'data/appointment_repository.dart';

/// Pentru demonstrarea stărilor:
/// `flutter run --dart-define=DEMO_STATE=empty` (sau `error`).
const _demoState = String.fromEnvironment('DEMO_STATE');

void main() {
  final assetPath = switch (_demoState) {
    'empty' => 'assets/data/lab_v2_empty.json',
    'error' => 'assets/data/missing.json', // nu există, intenționat
    _ => AssetAppointmentRepository.defaultAsset,
  };
  runApp(
    DoctorApp(repository: AssetAppointmentRepository(assetPath: assetPath)),
  );
}
