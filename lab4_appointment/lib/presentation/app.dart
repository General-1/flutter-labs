import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/appointment_repository.dart';
import '../domain/usecases/book_appointment.dart';
import '../domain/usecases/get_appointment_details.dart';
import '../domain/usecases/get_home_feed.dart';
import 'cubits/home_cubit.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

/// Rădăcina aplicației. Repository-ul vine din afară (doar interfața din
/// Domain), ca testele să poată folosi unul fals.
class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key, required this.repository});

  final AppointmentRepository repository;

  @override
  Widget build(BuildContext context) {
    // Cazurile de utilizare folosite de ecranul de detalii.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GetAppointmentDetails(repository)),
        RepositoryProvider(create: (_) => BookAppointment(repository)),
      ],
      // HomeCubit stă deasupra MaterialApp și pornește imediat încărcarea.
      child: BlocProvider(
        create: (_) => HomeCubit(GetHomeFeed(repository))..load(),
        child: MaterialApp(
          title: 'Doctor Appointment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
