import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/home_feed.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

/// Implementarea contractului din Domain: cere modelele de la sursele de date
/// și le transformă în entități.
class AppointmentRepositoryImpl implements AppointmentRepository {
  const AppointmentRepositoryImpl({
    required this.appointments,
    required this.bookings,
  });

  final AppointmentRemoteDataSource appointments;
  final BookingRemoteDataSource bookings;

  @override
  Future<HomeFeed> getHomeFeed() async =>
      (await appointments.fetchHomeFeed()).toEntity();

  @override
  Future<AppointmentDetails> getAppointmentDetails() async =>
      (await appointments.fetchAppointmentDetails()).toEntity();

  @override
  Future<BookingConfirmation> bookAppointment(Booking booking) async =>
      (await bookings.send(BookingRequestModel.fromEntity(booking))).toEntity();
}
