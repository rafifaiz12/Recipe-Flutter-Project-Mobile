import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/core/widgets/empty_state_widget.dart';

import 'package:siresep/models/shopping_item_model.dart';

import 'package:siresep/pages/shopping_list/add_manual_item_page.dart';

import 'package:siresep/pages/shopping_list/widgets/add_manual_item_card.dart';
import 'package:siresep/pages/shopping_list/widgets/shopping_list_section.dart';

import 'package:siresep/providers/shopping_list_provider.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<ShoppingListProvider>().loadItems();
    });
  }

  Future<void> _navigateToAddManualItemPage() async {
    final ShoppingItemModel? newItem = await Navigator.push<ShoppingItemModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddManualItemPage()),
    );

    if (newItem == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    await context.read<ShoppingListProvider>().addItem(newItem);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingListProvider>();

    final isEmpty = provider.shoppingItems.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShoppingListHeader(
                checkedItemsCount: provider.checkedItems,
                totalItemsCount: provider.totalItems,
                progressValue: provider.progressValue,
                onClearChecked: _showClearCheckedDialog,
              ),

              const SizedBox(height: AppSizes.spaceL),

              AddManualItemCard(onTap: _navigateToAddManualItemPage),

              const SizedBox(height: AppSizes.spaceL),

              if (isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSizes.spaceXL),
                  child: EmptyStateWidget(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Shopping list is empty',
                    subtitle:
                    'Tambahkan item manual atau generate dari recipe detail.',
                  ),
                )
              else
                ...provider.categories.map(
                      (category) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.spaceL,
                    ),
                    child: ShoppingListSection(
                      title: category,
                      items: provider.itemsByCategory(category),
                      onItemTap: (itemId) async {
                        await provider.toggleItem(itemId);
                      },
                      onDeleteTap: (itemId) async {
                        await provider.deleteItem(itemId);
                      },
                    ),
                  ),
                ),

              const SizedBox(height: AppSizes.spaceL),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showClearCheckedDialog() async {
    final provider = context.read<ShoppingListProvider>();

    if (provider.checkedItems == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada item yang dicentang.')),
      );
      return;
    }

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Hapus Item Selesai'),
              content: Text(
                '${provider.checkedItems} item yang sudah dicentang akan dihapus.',
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Batal'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) {
      return;
    }

    await provider.clearCheckedItems();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item selesai berhasil dihapus.')),
    );
  }
}

class _ShoppingListHeader extends StatelessWidget {
  final int checkedItemsCount;

  final int totalItemsCount;

  final double progressValue;

  final VoidCallback onClearChecked;

  const _ShoppingListHeader({
    required this.checkedItemsCount,
    required this.totalItemsCount,
    required this.progressValue,
    required this.onClearChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shopping List', style: AppTextStyles.h1),

            if (checkedItemsCount > 0)
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onClearChecked,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.delete_outline, color: AppColors.error),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSizes.spaceS),

        Text(
          '$checkedItemsCount of $totalItemsCount items',
          style: AppTextStyles.bodySecondary,
        ),

        const SizedBox(height: AppSizes.spaceM),

        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: AppSizes.paddingS,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
