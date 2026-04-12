import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/core/widgets/empty_state_widget.dart';
import 'package:siresep/pages/shopping_list/add_manual_item_page.dart';
import 'package:siresep/pages/shopping_list/widgets/add_manual_item_card.dart';
import 'package:siresep/pages/shopping_list/widgets/shopping_list_section.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  List<Map<String, dynamic>> get _shoppingItems => DummyData.shoppingItemsSnapshot;

  int get _checkedItemsCount =>
      _shoppingItems.where((item) => item['isChecked'] == true).length;

  int get _totalItemsCount => _shoppingItems.length;

  double get _progressValue {
    if (_totalItemsCount == 0) {
      return 0;
    }

    return _checkedItemsCount / _totalItemsCount;
  }

  List<String> get _categories {
    final Set<String> categorySet = _shoppingItems
        .map((item) => item['category'] as String)
        .toSet();

    return categorySet.toList();
  }

  List<Map<String, dynamic>> _itemsByCategory(String category) {
    return _shoppingItems
        .where((item) => item['category'] == category)
        .toList();
  }

  void _toggleItem(String id) {
    setState(() {
      DummyData.toggleShoppingItem(id);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      DummyData.removeShoppingItem(id);
    });
  }

  Future<void> _navigateToAddManualItemPage() async {
    final Map<String, dynamic>? newItem =
    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (_) => const AddManualItemPage(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      DummyData.addManualShoppingItem(
        name: newItem['name'] as String,
        quantity: newItem['quantity'] as String,
        unit: newItem['unit'] as String,
        category: newItem['category'] as String,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _shoppingItems.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShoppingListHeader(
                checkedItemsCount: _checkedItemsCount,
                totalItemsCount: _totalItemsCount,
                progressValue: _progressValue,
              ),
              const SizedBox(height: AppSizes.spaceL),
              AddManualItemCard(
                onTap: _navigateToAddManualItemPage,
              ),
              const SizedBox(height: AppSizes.spaceL),
              if (isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSizes.spaceXL),
                  child: EmptyStateWidget(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Shopping list is empty',
                    subtitle:
                    'Tambahkan item manual atau generate dari meal plan dan recipe detail.',
                  ),
                )
              else
                ..._categories.map(
                      (category) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.spaceL,
                    ),
                    child: ShoppingListSection(
                      title: category,
                      items: _itemsByCategory(category),
                      onItemTap: _toggleItem,
                      onDeleteTap: _deleteItem,
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
}

class _ShoppingListHeader extends StatelessWidget {
  final int checkedItemsCount;
  final int totalItemsCount;
  final double progressValue;

  const _ShoppingListHeader({
    required this.checkedItemsCount,
    required this.totalItemsCount,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Text(
          'Shopping List',
          style: AppTextStyles.h1,
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
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}