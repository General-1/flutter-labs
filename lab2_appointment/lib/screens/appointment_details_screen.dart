import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/doctor_avatar.dart';
import '../widgets/section_header.dart';
import '../widgets/selectable_chip.dart';

/// Ecranul 2 din Figma: „Appointment detailes”.
class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  static const _hours = [
    '10.00 AM',
    '11.00 AM',
    '12.00 PM',
    '01.00 PM',
    '02.00 PM',
    '03.00 PM',
  ];
  static const _days = ['Sun 4', 'Mon 5', 'Tue 6', 'Wed 7', 'Thu 8', 'Fri 9'];

  int _selectedHour = 1; // 11.00 AM, selectat ca în design
  int _selectedDay = 0; // Sun 4

  void _contact(String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$action ${widget.doctor.name}...')),
      );
  }

  void _book() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Appointment booked'),
        content: Text(
          '${widget.doctor.name} – ${widget.doctor.specialty}\n'
          '${_days[_selectedDay]} at ${_hours[_selectedHour]}\n'
          'Payment: \$${widget.doctor.fee.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
                const Expanded(
                  child: Text(
                    'Appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // echilibrează butonul Back
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                DoctorAvatar(doctor: doctor, size: 104, borderRadius: 8),
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
                          _RoundIconButton(
                            icon: Icons.chat_bubble_outline,
                            tooltip: 'Chat',
                            onTap: () => _contact('Opening chat with'),
                          ),
                          _RoundIconButton(
                            icon: Icons.call_outlined,
                            tooltip: 'Call',
                            onTap: () => _contact('Calling'),
                          ),
                          _RoundIconButton(
                            icon: Icons.videocam_outlined,
                            tooltip: 'Video call',
                            onTap: () => _contact('Starting video call with'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Payment',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Text(
                            '\$${doctor.fee.toStringAsFixed(2)}',
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
            ),
            const SizedBox(height: 28),
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              doctor.about,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Working Hours', fontSize: 18),
            const SizedBox(height: 14),
            _ChipRow(
              labels: _hours,
              selectedIndex: _selectedHour,
              onSelected: (i) => setState(() => _selectedHour = i),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Date', fontSize: 18),
            const SizedBox(height: 14),
            _ChipRow(
              labels: _days,
              selectedIndex: _selectedDay,
              onSelected: (i) => setState(() => _selectedDay = i),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _book,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book an Appointment',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rând orizontal de chip-uri, din care se poate selecta unul singur.
class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SelectableChip(
          label: labels[i],
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
      ),
    );
  }
}

/// Cercurile mici turcoaz pentru chat / call / video.
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.textDark),
          ),
        ),
      ),
    );
  }
}
