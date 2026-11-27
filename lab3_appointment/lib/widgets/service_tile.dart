import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/home_feed.dart';
import '../theme/app_colors.dart';

/// Un pătrățel din „Health Services”. Iconița SVG vine din `iconUrl`.
class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.service, this.onTap});

  final HealthService service;
  final VoidCallback? onTap;

  /// Se vede cât se încarcă iconița sau dacă nu există internet.
  static const _fallback = Icon(
    Icons.medical_services_outlined,
    color: AppColors.primary,
    size: 28,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.network(
              service.iconUrl,
              width: 32,
              height: 32,
              placeholderBuilder: (_) => _fallback,
              errorBuilder: (_, _, _) => _fallback,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
