import '../entities/appointment_details.dart';
import '../entities/booking.dart';
import '../entities/home_feed.dart';

/// Contractul de date al aplicației. Domain spune *ce* are nevoie; stratul Data
/// decide *cum* (HTTP, JSON). La eșec, metodele aruncă un `Failure`.
abstract class AppointmentRepository {
  Future<HomeFeed> getHomeFeed();

  Future<AppointmentDetails> getAppointmentDetails();

  Future<BookingConfirmation> bookAppointment(Booking booking);
}
