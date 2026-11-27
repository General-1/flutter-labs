import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/details_cubit.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../../domain/usecases/book_appointment.dart';
import '../../domain/usecases/get_appointment_details.dart';
import '../../domain/entities/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/appointment_card.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/filter_sort_sheet.dart';
import '../widgets/home_header.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import '../widgets/service_tile.dart';
import '../widgets/status_view.dart';
import 'appointment_details_screen.dart';

/// Ecranul 1 din Figma: „Homescreen”. Alege ce afișează după starea Cubit-ului.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          // `switch` pe o clasă `sealed`: compilatorul cere toate stările.
          builder: (context, state) => switch (state) {
            HomeLoading() => const LoadingView(),
            HomeError(:final message) => StatusView(
              icon: Icons.error_outline,
              message: message,
              actionLabel: 'Try again',
              onAction: () => context.read<HomeCubit>().load(),
            ),
            HomeEmpty() => StatusView(
              icon: Icons.person_search_outlined,
              message: 'No doctors available yet',
              actionLabel: 'Refresh',
              onAction: () => context.read<HomeCubit>().load(),
            ),
            HomeSuccess() => _HomeContent(state: state),
          },
        ),
      ),
    );
  }
}

/// Conținutul în starea Success. Este Stateful doar pentru controller-ul
/// câmpului de căutare; datele și alegerile stau în Cubit.
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.state});

  final HomeSuccess state;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late final _searchController = TextEditingController(
    text: widget.state.query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Navigare: deschidem detaliile cu un Cubit nou, care își încarcă datele.
  void _openDetails(Doctor doctor) {
    final getDetails = context.read<GetAppointmentDetails>();
    final bookAppointment = context.read<BookAppointment>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => DetailsCubit(
            getDetails: getDetails,
            bookAppointment: bookAppointment,
          )..load(),
          child: AppointmentDetailsScreen(doctor: doctor),
        ),
      ),
    );
  }

  void _clearAll() {
    _searchController.clear();
    context.read<HomeCubit>().clearAll();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final feed = state.feed;
    final cubit = context.read<HomeCubit>();
    final doctors = state.visibleDoctors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        HomeHeader(
          user: feed.user,
          hasUnread: feed.hasUnreadNotifications,
          onBellTap: () => _showMessage(
            feed.hasUnreadNotifications
                ? 'You have unread notifications'
                : 'No new notifications',
          ),
        ),
        const SizedBox(height: 20),
        SearchField(
          controller: _searchController,
          hint: feed.searchHint,
          filtersActive: state.hasActiveFilters,
          onChanged: cubit.search,
          onFilterTap: () => FilterSortSheet.show(context),
        ),
        const SizedBox(height: 20),
        AppointmentCard(
          appointment: feed.appointment,
          onTap: () => _openDetails(feed.appointment.doctor),
        ),
        const SizedBox(height: AppointmentCard.overlap + 24),
        const SectionHeader(title: 'Health Services'),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final service in feed.healthServices)
              ServiceTile(
                service: service,
                onTap: () =>
                    _showMessage('${service.name} specialists – coming soon'),
              ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Nearby Doctor'),
        const SizedBox(height: 4),
        if (doctors.isEmpty) ...[
          // Lista goală din cauza căutării sau a filtrelor.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Text(
                  'No doctors match your search or filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Text('Clear search and filters'),
                ),
              ],
            ),
          ),
        ],
        for (final doctor in doctors)
          DoctorTile(
            key: ValueKey(doctor.id),
            doctor: doctor,
            isFavorite: state.isFavorite(doctor),
            onFavoriteToggle: () => cubit.toggleFavorite(doctor.id),
            onTap: () => _openDetails(doctor),
          ),
      ],
    );
  }
}
