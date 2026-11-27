import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../theme/app_colors.dart';
import '../widgets/appointment_card.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/service_tile.dart';
import 'appointment_details_screen.dart';

/// Ecranul 1 din Figma: „Homescreen”.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _services = [
    ('🦷', 'Tooth'),
    ('👁️', 'Eye'),
    ('🫁', 'Lungs'),
    ('👂', 'Ear'),
  ];

  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _favorites = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Doctorii care se potrivesc cu textul din search (după nume sau specialitate).
  List<Doctor> get _filteredDoctors {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return nearbyDoctors;
    return nearbyDoctors
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.specialty.toLowerCase().contains(q))
        .toList();
  }

  // Navigare: deschidem ecranul de detalii și îi trimitem doctorul ales.
  void _openDetails(Doctor doctor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsScreen(doctor: doctor),
      ),
    );
  }

  void _toggleFavorite(Doctor doctor) {
    setState(() {
      if (!_favorites.remove(doctor.name)) _favorites.add(doctor.name);
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _filteredDoctors;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _Header(onBellTap: () => _showMessage('No new notifications')),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search something',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                suffixIcon: const Icon(Icons.tune, color: AppColors.textGrey),
                filled: true,
                fillColor: AppColors.field,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppointmentCard(
              doctor: upcomingDoctor,
              date: '22 October, 2023',
              time: '08:00 AM - 10:30 AM',
              onTap: () => _openDetails(upcomingDoctor),
            ),
            const SizedBox(height: AppointmentCard.overlap + 24),
            const SectionHeader(title: 'Health Services'),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final (emoji, label) in _services)
                  ServiceTile(
                    emoji: emoji,
                    label: label,
                    onTap: () => _showMessage('$label specialists – coming soon'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Nearby Doctor'),
            const SizedBox(height: 4),
            if (doctors.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No doctors found for "$_query"',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ),
            for (final doctor in doctors)
              DoctorTile(
                doctor: doctor,
                isFavorite: _favorites.contains(doctor.name),
                onFavoriteToggle: () => _toggleFavorite(doctor),
                onTap: () => _openDetails(doctor),
              ),
          ],
        ),
      ),
    );
  }
}

/// „Hi, Jonathan” + avatar + clopoțel cu punct roșu.
class _Header extends StatelessWidget {
  const _Header({required this.onBellTap});

  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFFE59866),
          child: Text(
            'J',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Jonathan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'May you always be healthy',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: onBellTap,
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none, color: AppColors.textDark),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
