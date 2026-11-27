import '../entities/appointment_details.dart';
import '../repositories/appointment_repository.dart';

/// Caz de utilizare: datele pentru ecranul de detalii.
class GetAppointmentDetails {
  const GetAppointmentDetails(this._repository);

  final AppointmentRepository _repository;

  Future<AppointmentDetails> call() => _repository.getAppointmentDetails();
}
