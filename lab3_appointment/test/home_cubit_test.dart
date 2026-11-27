import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_appointment/cubits/home_cubit.dart';
import 'package:lab3_appointment/cubits/home_state.dart';
import 'package:lab3_appointment/models/doctor.dart';

import 'helpers.dart';

/// Trei doctori cu ordine diferită după distanță și după nume.
const _doctors = [
  Doctor(
    id: 'b',
    name: 'Dr. Bob',
    specialty: 'Dentist',
    distance: 'X - 1.4KM from you',
  ),
  Doctor(
    id: 'c',
    name: 'Dr. Cara',
    specialty: 'Surgeon',
    distance: 'Y - 500M from you',
    isFavorite: true,
  ),
  Doctor(
    id: 'a',
    name: 'Dr. Ana',
    specialty: 'Dentist',
    distance: 'Z - 753M from you',
  ),
];

List<String> _ids(HomeState state) =>
    (state as HomeSuccess).visibleDoctors.map((d) => d.id).toList();

void main() {
  HomeCubit build() => HomeCubit(FakeRepository(feed: feedWith(_doctors)));

  group('stările de încărcare', () {
    blocTest<HomeCubit, HomeState>(
      'Loading → Success',
      build: () => HomeCubit(FakeRepository()),
      act: (cubit) => cubit.load(),
      expect: () => [const HomeLoading(), HomeSuccess(feed: sampleFeed)],
    );

    blocTest<HomeCubit, HomeState>(
      'Loading → Empty când nu există doctori',
      build: () => HomeCubit(FakeRepository(feed: emptyFeed)),
      act: (cubit) => cubit.load(),
      expect: () => const [HomeLoading(), HomeEmpty()],
    );

    blocTest<HomeCubit, HomeState>(
      'Loading → Error când sursa eșuează',
      build: () => HomeCubit(FakeRepository()..failHome = true),
      act: (cubit) => cubit.load(),
      expect: () => const [
        HomeLoading(),
        HomeError('Could not load the data.'),
      ],
      errors: () => [isA<FormatException>()],
    );

    test('o nouă încercare după Error ajunge în Success', () async {
      final repository = FakeRepository()..failHome = true;
      final cubit = HomeCubit(repository);
      await cubit.load();
      expect(cubit.state, isA<HomeError>());

      repository.failHome = false;
      await cubit.load();
      expect(cubit.state, isA<HomeSuccess>());
      await cubit.close();
    });

    test('închiderea în timpul încărcării nu produce erori', () async {
      final cubit = HomeCubit(FakeRepository());
      final loading = cubit.load();
      await cubit.close();
      await expectLater(loading, completes);
    });
  });

  group('interacțiuni', () {
    late HomeCubit cubit;

    setUp(() async {
      cubit = build();
      await cubit.load();
    });
    tearDown(() => cubit.close());

    test('favoritele inițiale vin din date', () {
      expect((cubit.state as HomeSuccess).favoriteIds, {'c'});
    });

    test('adăugare și eliminare din favorite', () {
      cubit.toggleFavorite('a');
      expect((cubit.state as HomeSuccess).favoriteIds, {'a', 'c'});

      cubit.toggleFavorite('c');
      expect((cubit.state as HomeSuccess).favoriteIds, {'a'});
    });

    test('căutare după nume sau specialitate', () {
      cubit.search('  ANA ');
      expect(_ids(cubit.state), ['a']);

      cubit.search('dentist');
      expect(_ids(cubit.state), ['b', 'a']);

      cubit.search('xyz');
      expect(_ids(cubit.state), isEmpty);
    });

    test('filtrare după specialitate și favorite', () {
      expect((cubit.state as HomeSuccess).specialties, ['Dentist', 'Surgeon']);

      cubit.filterBySpecialty('Dentist');
      expect(_ids(cubit.state), ['b', 'a']);

      cubit.filterBySpecialty(null);
      cubit.showFavoritesOnly(true);
      expect(_ids(cubit.state), ['c']);
    });

    test('toate sortările', () {
      expect(_ids(cubit.state), ['b', 'c', 'a']); // ordinea din date

      cubit.sortBy(DoctorSort.nearest);
      expect(_ids(cubit.state), ['c', 'a', 'b']);

      cubit.sortBy(DoctorSort.farthest);
      expect(_ids(cubit.state), ['b', 'a', 'c']);

      cubit.sortBy(DoctorSort.nameAsc);
      expect(_ids(cubit.state), ['a', 'b', 'c']);

      cubit.sortBy(DoctorSort.nameDesc);
      expect(_ids(cubit.state), ['c', 'b', 'a']);
    });

    test('resetFilters păstrează căutarea, clearAll o șterge', () {
      cubit
        ..search('dr')
        ..filterBySpecialty('Surgeon')
        ..sortBy(DoctorSort.nameAsc);

      cubit.resetFilters();
      var state = cubit.state as HomeSuccess;
      expect(state.query, 'dr');
      expect(state.hasActiveFilters, isFalse);

      cubit.clearAll();
      state = cubit.state as HomeSuccess;
      expect(state.query, isEmpty);
      expect(state.favoriteIds, {'c'});
    });
  });
}
