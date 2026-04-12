import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class ShoppingListItemTile extends StatelessWidget {
  final String id;
  final String name;
  final String quantity;
  final String unit;
  final bool isChecked;
  final bool isManual;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onDeleteTap;

  const ShoppingListItemTile({
    super.key,
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isChecked,
    required this.isManual,
    required this.onTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onTap(id),
            child: Container(
              width: AppSizes.iconL,
              height: AppSizes.iconL,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? AppColors.primary : AppColors.card,
                border: Border.all(
                  color: isChecked ? AppColors.primary : AppColors.border,
                ),
              ),
              child: isChecked
                  ? const Icon(
                Icons.check,
                color: AppColors.card,
                size: AppSizes.iconS,
              )
                  : null,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    decoration: isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isChecked
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                if (isManual) ...[
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    'Manual item',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '$quantity $unit',
            style: AppTextStyles.smallBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (isChecked) ...[
            const SizedBox(width: AppSizes.spaceS),
            GestureDetector(
              onTap: () => onDeleteTap(id),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: AppSizes.iconM,
              ),
            ),
          ],
        ],
      ),
    );
  }
}