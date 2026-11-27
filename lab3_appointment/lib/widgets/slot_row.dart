import 'package:flutter/material.dart';

import '../models/appointment_details.dart';
import '../theme/app_colors.dart';
import 'section_header.dart';
import 'selectable_chip.dart';

/// Titlu + rând orizontal de chip-uri, din care se alege unul singur.
class SlotRow extends StatelessWidget {
  const SlotRow({
    super.key,
    required this.section,
    required this.selectedId,
    required this.onSelected,
  });

  final SlotSection section;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final slots = section.slots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: section.title,
          fontSize: 18,
          showSeeAll: section.showAll,
        ),
        const SizedBox(height: 14),
        if (slots.isEmpty)
          const Text(
            'Nothing available',
            style: TextStyle(color: AppColors.textGrey),
          )
        else
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: slots.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SelectableChip(
                label: slots[i].label,
                selected: slots[i].id == selectedId,
                onTap: () => onSelected(slots[i].id),
              ),
            ),
          ),
      ],
    );
  }
}
