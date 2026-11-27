import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/book_appointment.dart';
import '../../domain/usecases/get_appointment_details.dart';
import 'details_state.dart';

/// Logica ecranului de detalii: încărcare, alegerea orei / zilei și trimiterea
/// programării.
class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit({required this._getDetails, required this._bookAppointment})
    : super(const DetailsLoading());

  final GetAppointmentDetails _getDetails;
  final BookAppointment _bookAppointment;

  Future<void> load() async {
    emit(const DetailsLoading());
    try {
      final details = await _getDetails();
      // Utilizatorul poate apăsa Back înainte să se termine încărcarea.
      if (isClosed) return;
      emit(
        DetailsSuccess(
          details: details,
          selectedHourId: details.workingHours.initialSlot?.id,
          selectedDateId: details.dates.initialSlot?.id,
        ),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(
        DetailsError(
          error is Failure ? error.message : 'Could not load the details.',
        ),
      );
    }
  }

  void selectHour(String id) {
    final current = state;
    if (current is DetailsSuccess) {
      emit(current.copyWith(selectedHourId: id));
    }
  }

  void selectDate(String id) {
    final current = state;
    if (current is DetailsSuccess) {
      emit(current.copyWith(selectedDateId: id));
    }
  }

  /// Trimite programarea: Sending → Sent / Failed.
  Future<void> book(String doctorName) async {
    final current = state;
    // `canBook` este fals și cât timp o cerere e în curs (fără dublu tap).
    if (current is! DetailsSuccess || !current.canBook) return;

    final booking = Booking(
      doctorName: doctorName,
      date: current.selectedDate!.label,
      hour: current.selectedHour!.label,
    );
    _setBooking(const BookingSending());
    try {
      final confirmation = await _bookAppointment(booking);
      _setBooking(BookingSent(booking, confirmation));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      _setBooking(
        BookingFailed(
          error is Failure ? error.message : 'Could not send the booking.',
        ),
      );
    }
  }

  void _setBooking(BookingStatus status) {
    final current = state;
    if (!isClosed && current is DetailsSuccess) {
      emit(current.copyWith(booking: status));
    }
  }
}
