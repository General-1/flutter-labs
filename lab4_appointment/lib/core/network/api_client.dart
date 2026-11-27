import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/failure.dart';
import 'api_config.dart';

/// Singurul loc din aplicație care vorbește HTTP. Trimite cererea, verifică
/// codul de răspuns și decodează JSON-ul. Orice problemă devine [Failure].
class ApiClient {
  ApiClient(this._client, {this.timeout = ApiConfig.timeout});

  final http.Client _client;
  final Duration timeout;

  Future<Map<String, dynamic>> getJson(Uri url) => _send(
    () => _client.get(url, headers: const {'Accept': 'application/json'}),
  );

  Future<Map<String, dynamic>> postJson(Uri url, Map<String, dynamic> body) =>
      _send(
        () => _client.post(
          url,
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(body),
        ),
      );

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(timeout);
    } on TimeoutException {
      throw const TimeoutFailure();
    } on Exception {
      // `ClientException`, erori de socket sau de certificat.
      throw const NetworkFailure();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerFailure(response.statusCode);
    }

    try {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json is Map<String, dynamic>) return json;
    } on FormatException {
      // Tratată mai jos, ca orice răspuns care nu e un obiect JSON.
    }
    throw const ParsingFailure();
  }
}
