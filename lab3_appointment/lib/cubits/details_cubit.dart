import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/appointment_repository.dart';
import 'details_state.dart';

/// Logica ecranului de detalii: încărcare și alegerea orei / zilei.
class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this._repository) : super(const DetailsLoading());

  final AppointmentRepository _repository;

  Future<void> load() async {
    emit(const DetailsLoading());
    try {
      final details = await _repository.loadAppointmentDetails();
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
      emit(const DetailsError('Could not load the details.'));
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
}
