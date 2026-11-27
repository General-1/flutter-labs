import 'package:equatable/equatable.dart';

import '../../domain/entities/doctor.dart';
import '../../domain/entities/home_feed.dart';

/// Opțiunile de sortare a listei de doctori.
enum DoctorSort {
  recommended('Recommended'),
  nearest('Nearest first'),
  farthest('Farthest first'),
  nameAsc('Name A–Z'),
  nameDesc('Name Z–A');

  const DoctorSort(this.label);

  final String label;
}

/// Stările Homescreen-ului: Loading, Success, Empty, Error.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Datele se încarcă.
final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Încărcarea a reușit, dar nu există niciun doctor în date.
final class HomeEmpty extends HomeState {
  const HomeEmpty();
}

/// Încărcarea a eșuat.
final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Datele sunt încărcate; ține și alegerile utilizatorului
/// (căutare, filtre, sortare, favorite).
final class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.feed,
    this.query = '',
    this.specialty,
    this.favoritesOnly = false,
    this.sort = DoctorSort.recommended,
    this.favoriteIds = const {},
  });

  final HomeFeed feed;
  final String query;

  /// `null` = toate specialitățile.
  final String? specialty;
  final bool favoritesOnly;
  final DoctorSort sort;
  final Set<String> favoriteIds;

  bool isFavorite(Doctor doctor) => favoriteIds.contains(doctor.id);

  /// Specialitățile care apar în date, pentru chip-urile de filtrare.
  List<String> get specialties =>
      {for (final d in feed.nearbyDoctors) d.specialty}.toList()..sort();

  /// `true` dacă este activ un filtru sau o altă sortare decât cea implicită.
  bool get hasActiveFilters =>
      specialty != null || favoritesOnly || sort != DoctorSort.recommended;

  /// Lista afișată: datele originale → căutare → filtre → sortare.
  List<Doctor> get visibleDoctors {
    final q = query.trim().toLowerCase();
    final result = feed.nearbyDoctors.where((d) {
      final matchesQuery =
          q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q);
      final matchesSpecialty = specialty == null || d.specialty == specialty;
      final matchesFavorite = !favoritesOnly || isFavorite(d);
      return matchesQuery && matchesSpecialty && matchesFavorite;
    }).toList();

    switch (sort) {
      case DoctorSort.recommended:
        break; // ordinea de pe server
      case DoctorSort.nearest:
        result.sort((a, b) => _compareDistance(a, b));
      case DoctorSort.farthest:
        result.sort((a, b) => _compareDistance(a, b, descending: true));
      case DoctorSort.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case DoctorSort.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
    }
    return result;
  }

  /// Doctorii fără distanță cunoscută rămân la final în ambele sensuri.
  static int _compareDistance(Doctor a, Doctor b, {bool descending = false}) {
    final x = a.distanceInMeters;
    final y = b.distanceInMeters;
    if (x == null || y == null) {
      if (x == y) return 0;
      return x == null ? 1 : -1;
    }
    return descending ? y.compareTo(x) : x.compareTo(y);
  }

  /// `specialty` este o funcție ca să putem seta și valoarea `null`.
  HomeSuccess copyWith({
    String? query,
    String? Function()? specialty,
    bool? favoritesOnly,
    DoctorSort? sort,
    Set<String>? favoriteIds,
  }) => HomeSuccess(
    feed: feed,
    query: query ?? this.query,
    specialty: specialty != null ? specialty() : this.specialty,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    sort: sort ?? this.sort,
    favoriteIds: favoriteIds ?? this.favoriteIds,
  );

  @override
  List<Object?> get props => [
    feed,
    query,
    specialty,
    favoritesOnly,
    sort,
    favoriteIds,
  ];
}
