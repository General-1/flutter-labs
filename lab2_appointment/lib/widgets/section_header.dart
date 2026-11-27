import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Titlu de secțiune cu „See All” în dreapta (ex. „Health Services”).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.fontSize = 16});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        Text(
          'See All',
          style: TextStyle(
            fontSize: fontSize >= 18 ? 14 : 11,
            color: fontSize >= 18 ? AppColors.textDark : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
