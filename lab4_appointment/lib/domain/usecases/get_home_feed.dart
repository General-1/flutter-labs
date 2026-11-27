import '../entities/home_feed.dart';
import '../repositories/appointment_repository.dart';

/// Caz de utilizare: datele pentru Homescreen.
class GetHomeFeed {
  const GetHomeFeed(this._repository);

  final AppointmentRepository _repository;

  Future<HomeFeed> call() => _repository.getHomeFeed();
}
