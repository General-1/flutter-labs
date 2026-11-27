/// Erorile pe care le cunoaște aplicația. Stratul Data transformă problemele
/// tehnice (rețea, timeout, JSON) în aceste obiecte, iar interfața afișează
/// doar mesajul.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Cererea nu a ajuns la server.
final class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('Cannot reach the server. Check your internet connection.');
}

/// Serverul nu a răspuns la timp.
final class TimeoutFailure extends Failure {
  const TimeoutFailure()
    : super(
        'The server took too long to answer. '
        'It may be waking up, please try again.',
      );
}

/// Serverul a răspuns cu un cod de eroare.
final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode)
    : super('The server returned an error ($statusCode).');

  final int statusCode;
}

/// Răspunsul nu are forma JSON așteptată.
final class ParsingFailure extends Failure {
  const ParsingFailure()
    : super('The server sent data the app could not read.');
}
