import '../entities/booking.dart';
import '../repositories/appointment_repository.dart';

/// Caz de utilizare: trimiterea unei programări.
class BookAppointment {
  const BookAppointment(this._repository);

  final AppointmentRepository _repository;

  Future<BookingConfirmation> call(Booking booking) =>
      _repository.bookAppointment(booking);
}
