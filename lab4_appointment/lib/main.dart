import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'data/datasources/appointment_remote_data_source.dart';
import 'data/datasources/booking_remote_data_source.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'presentation/app.dart';

/// Singurul loc care cunoaște toate straturile: construiește obiectele și le
/// leagă între ele (client HTTP → surse de date → repository → aplicație).
void main() {
  final api = ApiClient(http.Client());
  final repository = AppointmentRepositoryImpl(
    appointments: AppointmentRemoteDataSource(api),
    bookings: BookingRemoteDataSource(api),
  );
  runApp(DoctorApp(repository: repository));
}
