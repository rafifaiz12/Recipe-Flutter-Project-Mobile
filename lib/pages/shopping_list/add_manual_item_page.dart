import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/widgets/custom_text_field.dart';

class AddManualItemPage extends StatefulWidget {
  const AddManualItemPage({super.key});

  @override
  State<AddManualItemPage> createState() => _AddManualItemPageState();
}

class _AddManualItemPageState extends State<AddManualItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final List<String> _unitOptions = ['gr', 'pcs', 'kg', 'ml', 'L'];
  final List<String> _categoryOptions = [
    'Pasta & Grains',
    'Dairy & Eggs',
    'Meat & Fish',
    'Fruits & Vegetables',
    'Others',
  ];

  String _selectedUnit = 'pcs';
  String _selectedCategory = 'Others';

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop<Map<String, dynamic>>(
      context,
      {
        'name': _itemNameController.text.trim(),
        'quantity': _quantityController.text.trim(),
        'unit': _selectedUnit,
        'category': _selectedCategory,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Manual Item'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add item to shopping list',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  'Fill in the item name, quantity, unit, and category.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSizes.spaceL),
                _FormLabel(label: 'Item Name'),
                const SizedBox(height: AppSizes.spaceS),
                CustomTextField(
                  controller: _itemNameController,
                  hintText: 'Enter item name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Item name cannot be empty';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceL),
                _FormLabel(label: 'Quantity'),
                const SizedBox(height: AppSizes.spaceS),
                CustomTextField(
                  controller: _quantityController,
                  hintText: 'Enter quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity cannot be empty';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceL),
                _FormLabel(label: 'Unit'),
                const SizedBox(height: AppSizes.spaceS),
                _SelectionContainer(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.body,
                    dropdownColor: AppColors.card,
                    items: _unitOptions
                        .map(
                          (unit) => DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedUnit = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                _FormLabel(label: 'Category'),
                const SizedBox(height: AppSizes.spaceS),
                _SelectionContainer(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.body,
                    dropdownColor: AppColors.card,
                    items: _categoryOptions
                        .map(
                          (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXL),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Save Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;

  const _FormLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.smallBold,
    );
  }
}

class _SelectionContainer extends StatelessWidget {
  final Widget child;

  const _SelectionContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: child,
    );
  }
}