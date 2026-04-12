import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class MealRecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String subtitle;
  final VoidCallback onTap;

  const MealRecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.textPrimary.withValues(alpha: 0.08),
                  AppColors.textPrimary.withValues(alpha: 0.45),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.card,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.card),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
