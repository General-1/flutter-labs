import 'package:flutter/material.dart';

/// Poza dintr-un URL. Cât se încarcă sau dacă nu se poate încărca (fără
/// internet), se văd inițialele pe fundal colorat, ca în laboratorul 2.
class NetworkAvatar extends StatelessWidget {
  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    required this.initials,
    this.size = 40,
    this.borderRadius,
  });

  final String imageUrl;
  final String initials;
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
    final placeholder = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color:
          _palette[initials.codeUnits.fold(0, (a, b) => a + b) %
              _palette.length],
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.36,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? size / 2),
      child: imageUrl.isEmpty
          ? placeholder
          : Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              frameBuilder: (_, child, frame, wasSynchronouslyLoaded) =>
                  wasSynchronouslyLoaded || frame != null ? child : placeholder,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}
