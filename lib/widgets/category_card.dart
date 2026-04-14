import 'package:flutter/material.dart';

import 'zinko_common_card.dart';
import '../core/theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZinkoCommonCard(
      width: 100,
      isSelected: isSelected,
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 28,
            color: isSelected ? AppColors.white : AppColors.brightBlue,
          ),
          const SizedBox(height: 8),
          Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? AppColors.white : AppColors.white.withAlpha((0.7 * 255).round()),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'co-working':
        return Icons.workspaces_outline;
      case 'café':
      case 'cafe':
        return Icons.local_cafe_outlined;
      case 'meeting room':
        return Icons.meeting_room_outlined;
      case 'private office':
        return Icons.business_outlined;
      case 'event space':
        return Icons.event_outlined;
      default:
        return Icons.work_outline;
    }
  }
}
