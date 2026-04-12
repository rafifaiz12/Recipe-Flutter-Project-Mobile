import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class EmptyMealCard extends StatelessWidget {
  final String label;

  const EmptyMealCard({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 52,
        horizontal: AppSizes.paddingL,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.add,
            size: 44,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            label,
            style: AppTextStyles.bodySecondary.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}