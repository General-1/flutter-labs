import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Un pătrățel din „Health Services” (Tooth, Eye, Lungs, Ear).
class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.emoji,
    required this.label,
    this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback? onTap;

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
            child: Text(emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
