import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Titlu de secțiune cu „See All” opțional în dreapta.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.fontSize = 16,
    this.showSeeAll = true,
  });

  final String title;
  final double fontSize;
  final bool showSeeAll;

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
        if (showSeeAll)
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
