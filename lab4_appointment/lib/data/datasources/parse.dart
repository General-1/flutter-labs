import '../../core/error/failure.dart';

/// Transformă JSON-ul într-un model. Un câmp lipsă sau de alt tip face codul
/// generat să arunce `TypeError`; îl raportăm ca [ParsingFailure].
T parse<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromJson,
) {
  try {
    return fromJson(json);
  } on TypeError {
    throw const ParsingFailure();
  }
}
