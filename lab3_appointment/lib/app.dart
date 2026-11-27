import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/home_cubit.dart';
import 'data/appointment_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

/// Rădăcina aplicației. Repository-ul vine din afară, ca testele să poată
/// folosi unul fals.
class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key, required this.repository});

  final AppointmentRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AppointmentRepository>.value(
      value: repository,
      // HomeCubit stă deasupra MaterialApp și pornește imediat încărcarea.
      child: BlocProvider(
        create: (_) => HomeCubit(repository)..load(),
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
