import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/appointment_repository.dart';
import 'home_state.dart';

/// Logica Homescreen-ului. Ecranul doar apelează metodele de aici și
/// redesenează în funcție de starea emisă.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeLoading());

  final AppointmentRepository _repository;

  /// Încarcă datele: Loading → Success / Empty / Error.
  Future<void> load() async {
    emit(const HomeLoading());
    try {
      final feed = await _repository.loadHomeFeed();
      if (isClosed) return;
      if (feed.nearbyDoctors.isEmpty) {
        emit(const HomeEmpty());
      } else {
        emit(
          HomeSuccess(
            feed: feed,
            favoriteIds: {
              for (final d in feed.nearbyDoctors)
                if (d.isFavorite) d.id,
            },
          ),
        );
      }
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(const HomeError('Could not load the data.'));
    }
  }

  void search(String query) => _update((s) => s.copyWith(query: query));

  void filterBySpecialty(String? specialty) =>
      _update((s) => s.copyWith(specialty: () => specialty));

  void showFavoritesOnly(bool value) =>
      _update((s) => s.copyWith(favoritesOnly: value));

  void sortBy(DoctorSort sort) => _update((s) => s.copyWith(sort: sort));

  /// Adaugă sau scoate un doctor din favorite.
  void toggleFavorite(String doctorId) => _update((s) {
    final ids = {...s.favoriteIds};
    if (!ids.remove(doctorId)) ids.add(doctorId);
    return s.copyWith(favoriteIds: ids);
  });

  /// Scoate filtrele și sortarea; textul căutat rămâne.
  void resetFilters() => _update(
    (s) => s.copyWith(
      specialty: () => null,
      favoritesOnly: false,
      sort: DoctorSort.recommended,
    ),
  );

  /// Scoate și textul căutat, și filtrele. Favoritele rămân.
  void clearAll() =>
      _update((s) => HomeSuccess(feed: s.feed, favoriteIds: s.favoriteIds));

  /// Alegerile utilizatorului au sens doar când datele sunt încărcate.
  void _update(HomeSuccess Function(HomeSuccess current) change) {
    final current = state;
    if (current is HomeSuccess) emit(change(current));
  }
}
