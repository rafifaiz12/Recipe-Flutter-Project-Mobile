import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class EmptyMealCard
    extends StatelessWidget {
  final String label;

  final VoidCallback onTap;

  const EmptyMealCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius:
      BorderRadius.circular(
        AppSizes.radiusXL,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusXL,
        ),
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(
            vertical: 52,
            horizontal:
            AppSizes.paddingL,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius:
            BorderRadius.circular(
              AppSizes.radiusXL,
            ),
            border: Border.all(
              color: AppColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 68,
                width: 68,
                decoration:
                BoxDecoration(
                  color:
                  AppColors
                      .inputBg,
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 36,
                  color: AppColors
                      .textSecondary,
                ),
              ),

              const SizedBox(
                height:
                AppSizes.spaceL,
              ),

              Text(
                label,
                style: AppTextStyles
                    .body
                    .copyWith(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 17,
                ),
              ),

              const SizedBox(
                height:
                AppSizes.spaceXS,
              ),

              Text(
                'Tap to add recipe',
                style:
                AppTextStyles
                    .caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}