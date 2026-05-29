import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class ServingsSelector
    extends StatelessWidget {
  final int selectedServings;

  final VoidCallback onDecrease;

  final VoidCallback onIncrease;

  const ServingsSelector({
    super.key,
    required this.selectedServings,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal:
        AppSizes.paddingM,
        vertical:
        AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusXL,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onDecrease,
            child: const Icon(
              Icons.remove,
              color:
              AppColors
                  .textPrimary,
              size: AppSizes.iconM,
            ),
          ),

          const SizedBox(
            width:
            AppSizes.spaceM,
          ),

          Text(
            '$selectedServings servings',
            style:
            AppTextStyles.body
                .copyWith(
              fontWeight:
              FontWeight.w500,
            ),
          ),

          const SizedBox(
            width:
            AppSizes.spaceM,
          ),

          GestureDetector(
            onTap: onIncrease,
            child: const Icon(
              Icons.add,
              color:
              AppColors
                  .textPrimary,
              size: AppSizes.iconM,
            ),
          ),
        ],
      ),
    );
  }
}