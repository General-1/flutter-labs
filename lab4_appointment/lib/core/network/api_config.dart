/// Adresele serviciilor Web.
abstract final class ApiConfig {
  /// Serviciul de date (varianta 2). Se poate schimba la rulare cu
  /// `--dart-define=API_BASE_URL=...` (ex. pentru proxy-ul din `tool/`).
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://test-api-jlbn.onrender.com/lab2026/v2',
  );

  /// Al doilea serviciu, pentru trimiterea programării. Este un server public
  /// de test: răspunde ca și cum ar fi salvat, dar nu păstrează nimic.
  static const bookingBaseUrl = 'https://jsonplaceholder.typicode.com';

  /// Serverul gratuit adoarme; prima cerere poate dura aproape un minut.
  static const timeout = Duration(seconds: 60);
}
