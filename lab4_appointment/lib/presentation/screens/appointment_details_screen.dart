import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/details_cubit.dart';
import '../cubits/details_state.dart';
import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/network_avatar.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/slot_row.dart';
import '../widgets/status_view.dart';

/// Ecranul 2 din Figma: „Appointment detailes”.
///
/// Numele, specialitatea și poza sunt ale doctorului ales pe Homescreen.
/// Plata, descrierea, orele și zilele vin din `GET /feed/details`, care
/// întoarce același răspuns pentru toți doctorii (nu primește un `id`).
class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  /// Reacționează o singură dată la rezultatul cererii de programare.
  void _onBookingResult(BuildContext context, DetailsSuccess state) {
    switch (state.booking) {
      case BookingSent(:final booking, :final confirmation):
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Appointment booked'),
            content: Text(
              '${doctor.name} – ${doctor.specialty}\n'
              '${booking.date} at ${booking.hour}\n'
              '${state.details.paymentLabel}: '
              '${state.details.paymentFormatted}\n\n'
              'Reference #${confirmation.reference} '
              '(test server, nothing is stored)',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      case BookingFailed(:final message):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      case BookingIdle() || BookingSending():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsCubit, DetailsState>(
      listenWhen: (previous, current) =>
          previous is DetailsSuccess &&
          current is DetailsSuccess &&
          previous.booking != current.booking,
      listener: (context, state) =>
          _onBookingResult(context, state as DetailsSuccess),
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: state is DetailsSuccess
                      ? state.details.title
                      : 'Appointment',
                ),
                Expanded(
                  child: switch (state) {
                    DetailsLoading() => const LoadingView(),
                    DetailsError(:final message) => StatusView(
                      icon: Icons.error_outline,
                      message: message,
                      actionLabel: 'Try again',
                      onAction: () => context.read<DetailsCubit>().load(),
                    ),
                    DetailsSuccess() => _DetailsContent(
                      doctor: doctor,
                      state: state,
                    ),
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: state is DetailsSuccess
              ? _BookButton(
                  label: state.details.bookLabel,
                  isSending: state.isSending,
                  onPressed: state.canBook
                      ? () => context.read<DetailsCubit>().book(doctor.name)
                      : null,
                )
              : null,
        );
      },
    );
  }
}

/// Butonul Back și titlul centrat.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 48), // echilibrează butonul Back
        ],
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.doctor, required this.state});

  final Doctor doctor;
  final DetailsSuccess state;

  @override
  Widget build(BuildContext context) {
    final details = state.details;
    final cubit = context.read<DetailsCubit>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      children: [
        _DoctorSummary(doctor: doctor, details: details),
        const SizedBox(height: 28),
        Text(
          details.aboutTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          details.about,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 28),
        SlotRow(
          section: details.workingHours,
          selectedId: state.selectedHourId,
          onSelected: cubit.selectHour,
        ),
        const SizedBox(height: 24),
        SlotRow(
          section: details.dates,
          selectedId: state.selectedDateId,
          onSelected: cubit.selectDate,
        ),
      ],
    );
  }
}

/// Poza, numele, butoanele de contact și plata.
class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.doctor, required this.details});

  final Doctor doctor;
  final AppointmentDetails details;

  void _contact(BuildContext context, String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$action ${doctor.name}...')));
  }

  @override
  Widget build(BuildContext context) {
    final actions = details.doctor;

    return Row(
      children: [
        NetworkAvatar(
          imageUrl: doctor.avatarUrl,
          initials: doctor.initials,
          size: 104,
          borderRadius: 8,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doctor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  if (actions.canMessage)
                    RoundIconButton(
                      icon: Icons.chat_bubble_outline,
                      tooltip: 'Chat',
                      onTap: () => _contact(context, 'Opening chat with'),
                    ),
                  if (actions.canCall)
                    RoundIconButton(
                      icon: Icons.call_outlined,
                      tooltip: 'Call',
                      onTap: () => _contact(context, 'Calling'),
                    ),
                  if (actions.canVideoCall)
                    RoundIconButton(
                      icon: Icons.videocam_outlined,
                      tooltip: 'Video call',
                      onTap: () =>
                          _contact(context, 'Starting video call with'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: const TextStyle(fontSize: 13, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      details.paymentLabel,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Text(
                    details.paymentFormatted,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookButton extends StatelessWidget {
  const _BookButton({
    required this.label,
    required this.isSending,
    required this.onPressed,
  });

  final String label;

  /// Cât se trimite cererea, textul este înlocuit de un indicator.
  final bool isSending;

  /// `null` dezactivează butonul.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isSending
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
