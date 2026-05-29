import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/shopping_item_model.dart';

import 'package:siresep/pages/shopping_list/widgets/shopping_list_item_tile.dart';

class ShoppingListSection
    extends StatelessWidget {
  final String title;

  final List<ShoppingItemModel>
  items;

  final ValueChanged<String>
  onItemTap;

  final ValueChanged<String>
  onDeleteTap;

  const ShoppingListSection({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles
              .bodySecondary
              .copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(
          height: AppSizes.spaceM,
        ),

        ...items.map(
              (item) => Padding(
            padding:
            const EdgeInsets.only(
              bottom:
              AppSizes.spaceM,
            ),
            child:
            ShoppingListItemTile(
              item: item,
              onTap: onItemTap,
              onDeleteTap:
              onDeleteTap,
            ),
          ),
        ),
      ],
    );
  }
}