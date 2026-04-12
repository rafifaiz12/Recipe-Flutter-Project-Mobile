import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/pages/shopping_list/add_manual_item_page.dart';
import 'package:siresep/pages/shopping_list/widgets/add_manual_item_card.dart';
import 'package:siresep/pages/shopping_list/widgets/shopping_list_section.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<Map<String, dynamic>> _shoppingItems = [
    {
      'id': '1',
      'name': 'Spaghetti',
      'quantity': '400',
      'unit': 'g',
      'category': 'Pasta & Grains',
      'isChecked': false,
      'isManual': false,
    },
    {
      'id': '2',
      'name': 'Eggs',
      'quantity': '4',
      'unit': 'pcs',
      'category': 'Dairy & Eggs',
      'isChecked': false,
      'isManual': false,
    },
    {
      'id': '3',
      'name': 'Parmesan cheese',
      'quantity': '100',
      'unit': 'g',
      'category': 'Dairy & Eggs',
      'isChecked': true,
      'isManual': false,
    },
    {
      'id': '4',
      'name': 'Greek yogurt',
      'quantity': '500',
      'unit': 'g',
      'category': 'Dairy & Eggs',
      'isChecked': true,
      'isManual': false,
    },
    {
      'id': '5',
      'name': 'Bacon',
      'quantity': '200',
      'unit': 'g',
      'category': 'Meat & Fish',
      'isChecked': false,
      'isManual': false,
    },
    {
      'id': '6',
      'name': 'Salmon fillet',
      'quantity': '2',
      'unit': 'pcs',
      'category': 'Meat & Fish',
      'isChecked': false,
      'isManual': false,
    },
    {
      'id': '7',
      'name': 'Strawberries',
      'quantity': '250',
      'unit': 'g',
      'category': 'Fruits & Vegetables',
      'isChecked': false,
      'isManual': false,
    },
    {
      'id': '8',
      'name': 'Milk',
      'quantity': '1',
      'unit': 'L',
      'category': 'Dairy & Eggs',
      'isChecked': false,
      'isManual': false,
    },
  ];

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
      final int index = _shoppingItems.indexWhere((item) => item['id'] == id);

      if (index == -1) {
        return;
      }

      _shoppingItems[index]['isChecked'] =
      !(_shoppingItems[index]['isChecked'] as bool);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _shoppingItems.removeWhere((item) => item['id'] == id);
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
      _shoppingItems.add({
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'name': newItem['name'],
        'quantity': newItem['quantity'],
        'unit': newItem['unit'],
        'category': newItem['category'],
        'isChecked': false,
        'isManual': true,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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