import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../theme/app_colors.dart';

/// Panoul de jos cu filtre (specialitate, favorite) și sortare.
/// Fiecare alegere se aplică imediat listei din spate.
class FilterSortSheet extends StatelessWidget {
  const FilterSortSheet({super.key});

  static Future<void> show(BuildContext context) {
    // Panoul este o rută separată, deci îi transmitem Cubit-ul existent.
    final cubit = context.read<HomeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const FilterSortSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();
        final cubit = context.read<HomeCubit>();

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Title('Specialty'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Option(
                      label: 'All',
                      selected: state.specialty == null,
                      onTap: () => cubit.filterBySpecialty(null),
                    ),
                    for (final specialty in state.specialties)
                      _Option(
                        label: specialty,
                        selected: state.specialty == specialty,
                        onTap: () => cubit.filterBySpecialty(specialty),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Favorites only'),
                  value: state.favoritesOnly,
                  onChanged: cubit.showFavoritesOnly,
                ),
                const _Title('Sort by'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final sort in DoctorSort.values)
                      _Option(
                        label: sort.label,
                        selected: state.sort == sort,
                        onTap: () => cubit.sortBy(sort),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: cubit.resetFilters,
                      child: const Text('Reset'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.chip,
      side: BorderSide.none,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textDark,
      ),
    );
  }
}
