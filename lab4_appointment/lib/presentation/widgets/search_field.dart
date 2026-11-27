import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Câmpul de căutare; iconița din dreapta deschide filtrele și sortarea.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onFilterTap,
    this.filtersActive = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final bool filtersActive;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        suffixIcon: IconButton(
          tooltip: 'Filter and sort',
          onPressed: onFilterTap,
          // Punctul arată că există un filtru sau o sortare activă.
          icon: Badge(
            isLabelVisible: filtersActive,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.tune,
              color: filtersActive ? AppColors.primary : AppColors.textGrey,
            ),
          ),
        ),
        filled: true,
        fillColor: AppColors.field,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
