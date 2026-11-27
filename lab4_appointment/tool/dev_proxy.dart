// Proxy local, doar pentru a rula aplicația în browser.
//
// Serverul de test nu trimite antetele CORS, deci Chrome/Edge nu lasă aplicația
// să citească răspunsul. Pe Android și Windows proxy-ul NU este necesar.
//
//   dart run tool/dev_proxy.dart
//   flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8787/lab2026/v2
import 'dart:io';

const _target = 'test-api-jlbn.onrender.com';
const _port = 8787;

Future<void> main() async {
  // Ascultă doar pe calculatorul local.
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, _port);
  final client = HttpClient();
  stdout.writeln('Proxy: http://127.0.0.1:$_port -> https://$_target');

  await for (final request in server) {
    _forward(client, request);
  }
}

/// Repetă cererea GET către server și adaugă antetul CORS la răspuns.
Future<void> _forward(HttpClient client, HttpRequest request) async {
  final response = request.response;
  response.headers.set('Access-Control-Allow-Origin', '*');
  try {
    if (request.method != 'GET') {
      response.statusCode = HttpStatus.methodNotAllowed;
    } else {
      final url = Uri.https(_target, request.uri.path);
      final upstream = await (await client.getUrl(url)).close();
      response.statusCode = upstream.statusCode;
      response.headers.contentType = upstream.headers.contentType;
      await response.addStream(upstream);
    }
    stdout.writeln(
      '${request.method} ${request.uri.path} -> '
      '${response.statusCode}',
    );
  } on Exception catch (error) {
    stderr.writeln('Proxy error: $error');
    response.statusCode = HttpStatus.badGateway;
  }
  await response.close();
}
