import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab4_appointment/core/error/failure.dart';
import 'package:lab4_appointment/core/network/api_client.dart';
import 'package:lab4_appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:lab4_appointment/data/datasources/booking_remote_data_source.dart';
import 'package:lab4_appointment/data/repositories/appointment_repository_impl.dart';
import 'package:lab4_appointment/domain/entities/booking.dart';

import 'helpers.dart';

/// Repository-ul real, dar cu un client HTTP fals: nicio cerere pe internet.
AppointmentRepositoryImpl repository(
  MockClientHandler handler, {
  Duration timeout = const Duration(seconds: 1),
}) {
  final api = ApiClient(MockClient(handler), timeout: timeout);
  return AppointmentRepositoryImpl(
    appointments: AppointmentRemoteDataSource(
      api,
      baseUrl: 'https://example.test/v2',
    ),
    bookings: BookingRemoteDataSource(api, baseUrl: 'https://booking.test'),
  );
}

http.Response json(String body, [int status = 200]) => http.Response(
  body,
  status,
  headers: const {'content-type': 'application/json'},
);

const booking = Booking(
  doctorName: 'Dr. Sonja Litel',
  date: 'Mon 5',
  hour: '12.00 PM',
);

void main() {
  test('GET /feed și GET /feed/details ajung entități', () async {
    final requests = <String>[];
    final repo = repository((request) async {
      requests.add('${request.method} ${request.url}');
      return json(
        readFixture(
          request.url.path.endsWith('details') ? detailsFixture : feedFixture,
        ),
      );
    });

    expect(await repo.getHomeFeed(), sampleFeed);
    expect(await repo.getAppointmentDetails(), sampleDetails);
    expect(requests, [
      'GET https://example.test/v2/feed',
      'GET https://example.test/v2/feed/details',
    ]);
  });

  test('programarea se trimite cu POST și corp JSON', () async {
    late http.Request sent;
    final repo = repository((request) async {
      sent = request;
      return json('{"id": 101}', 201);
    });

    final confirmation = await repo.bookAppointment(booking);

    expect(confirmation.reference, 101);
    expect(sent.method, 'POST');
    expect(sent.url.toString(), 'https://booking.test/posts');
    expect(sent.headers['Content-Type'], startsWith('application/json'));
    // Se trimit doar doctorul, ziua și ora.
    expect(jsonDecode(sent.body), {
      'doctorName': 'Dr. Sonja Litel',
      'date': 'Mon 5',
      'hour': '12.00 PM',
    });
  });

  group('erorile devin Failure', () {
    test('cod HTTP de eroare', () {
      final repo = repository(
        (_) async => http.Response('Page not found', 404),
      );

      expect(
        repo.getHomeFeed(),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 404),
        ),
      );
    });

    test('fără conexiune', () {
      final repo = repository((_) async => throw http.ClientException('off'));

      expect(repo.getHomeFeed(), throwsA(isA<NetworkFailure>()));
    });

    test('serverul răspunde prea târziu', () {
      final repo = repository((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return json('{}');
      }, timeout: const Duration(milliseconds: 20));

      expect(repo.getHomeFeed(), throwsA(isA<TimeoutFailure>()));
    });

    for (final (name, body) in [
      ('răspuns care nu e JSON', '<html></html>'),
      ('JSON care nu e un obiect', '[1, 2]'),
      ('câmpuri lipsă', '{"user": {}}'),
      ('câmp de alt tip', '{"id": "o sută"}'),
    ]) {
      test(name, () {
        final repo = repository((_) async => json(body));

        expect(repo.getHomeFeed(), throwsA(isA<ParsingFailure>()));
        expect(repo.bookAppointment(booking), throwsA(isA<ParsingFailure>()));
      });
    }

    test('POST refuzat de server', () {
      final repo = repository((_) async => json('{}', 500));

      expect(repo.bookAppointment(booking), throwsA(isA<ServerFailure>()));
    });
  });
}
