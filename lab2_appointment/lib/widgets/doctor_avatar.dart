import 'package:flutter/material.dart';

import '../models/doctor.dart';

/// Placeholder pentru poza doctorului: un pătrat/cerc colorat cu inițialele.
class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({
    super.key,
    required this.doctor,
    this.size = 40,
    this.borderRadius,
  });

  final Doctor doctor;
  final double size;

  /// `null` = cerc; altfel colțuri rotunjite cu raza dată.
  final double? borderRadius;

  static const _palette = [
    Color(0xFF6C9BD2),
    Color(0xFFE59866),
    Color(0xFF7DCEA0),
    Color(0xFFBB8FCE),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _palette[doctor.name.length % _palette.length],
        borderRadius: BorderRadius.circular(borderRadius ?? size / 2),
      ),
      child: Text(
        doctor.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
