import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/shopping_item_model.dart';

class ShoppingListItemTile
    extends StatelessWidget {
  final ShoppingItemModel item;

  final ValueChanged<String>
  onTap;

  final ValueChanged<String>
  onDeleteTap;

  const ShoppingListItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDeleteTap,
  });

  String formatQuantity(
      double quantity,
      ) {
    if (quantity ==
        quantity.roundToDouble()) {
      return quantity
          .toInt()
          .toString();
    }

    return quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal:
        AppSizes.paddingM,
        vertical:
        AppSizes.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusL,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap:
                () => onTap(item.id),
            child: Container(
              width: AppSizes.iconL,
              height:
              AppSizes.iconL,
              decoration:
              BoxDecoration(
                shape:
                BoxShape.circle,
                color:
                item.isChecked
                    ? AppColors
                    .primary
                    : AppColors
                    .card,
                border: Border.all(
                  color:
                  item.isChecked
                      ? AppColors
                      .primary
                      : AppColors
                      .border,
                ),
              ),
              child:
              item.isChecked
                  ? const Icon(
                Icons.check,
                color:
                AppColors.card,
                size:
                AppSizes.iconS,
              )
                  : null,
            ),
          ),

          const SizedBox(
            width: AppSizes.spaceM,
          ),

          Expanded(
            child: Text(
              item.name,
              style: AppTextStyles
                  .body
                  .copyWith(
                decoration:
                item.isChecked
                    ? TextDecoration
                    .lineThrough
                    : TextDecoration
                    .none,
                color:
                item.isChecked
                    ? AppColors
                    .textSecondary
                    : AppColors
                    .textPrimary,
              ),
            ),
          ),

          const SizedBox(
            width: AppSizes.spaceS,
          ),
          Text(
            '${formatQuantity(double.tryParse(item.quantity) ?? 0)} ${item.unit}',
            style: AppTextStyles
                .smallBold
                .copyWith(
              color: AppColors
                  .textSecondary,
            ),
          ),

          const SizedBox(
            width: AppSizes.spaceS,
          ),

          GestureDetector(
            onTap:
                () =>
                onDeleteTap(
                  item.id,
                ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: AppSizes.iconM,
            ),
          ),
        ],
      ),
    );
  }
}