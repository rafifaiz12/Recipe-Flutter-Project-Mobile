import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/models/shopping_item_model.dart';

import 'package:siresep/services/shopping_list_service.dart';

class ShoppingListProvider
    extends ChangeNotifier {
  ShoppingListProvider() {
    loadItems();
  }
  final ShoppingListService
  _service =
  ShoppingListService();

  List<ShoppingItemModel>
  _shoppingItems = [];

  bool _isLoading = false;

  List<ShoppingItemModel>
  get shoppingItems =>
      _shoppingItems;

  bool get isLoading =>
      _isLoading;

  int get totalItems =>
      _shoppingItems.length;

  int get totalShoppingItems =>
      _shoppingItems.length;

  int get checkedItems =>
      _shoppingItems
          .where(
            (item) =>
        item.isChecked,
      )
          .length;

  double get progressValue {
    if (_shoppingItems
        .isEmpty) {
      return 0;
    }

    return checkedItems /
        totalItems;
  }

  List<String> get categories {
    final Set<String>
    categorySet =
    _shoppingItems
        .map(
          (item) =>
      item.category,
    )
        .toSet();

    return categorySet
        .toList();
  }

  Future<void>
  loadItems() async {
    _isLoading = true;

    notifyListeners();

    try {
      _shoppingItems =
      await _service
          .getShoppingItems();
    } catch (_) {
      _shoppingItems = [];
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  List<ShoppingItemModel>
  itemsByCategory(
      String category,
      ) {
    return _shoppingItems
        .where(
          (item) =>
      item.category ==
          category,
    )
        .toList();
  }

  Future<void> addItem(
      ShoppingItemModel item,
      ) async {
    await _service.addItem(
      item,
    );

    await loadItems();
  }

  Future<void>
  addRecipeIngredients(
      RecipeModel recipe,
      int selectedServings,
      ) async {
    final List<
        ShoppingItemModel>
    items =
    recipe.ingredients
        .map(
          (
          ingredient,
          ) {
            final baseServings =
            recipe.servings <= 0
                ? 1
                : recipe.servings;

            final scaledQuantity =
                (ingredient.quantity /
                    baseServings) *
                    selectedServings;

        return ShoppingItemModel(
          id:
          '${recipe.id}_${ingredient.name}_${DateTime.now().millisecondsSinceEpoch}',
          userId:
          FirebaseAuth
              .instance
              .currentUser
              ?.uid ??
              '',
          name:
          ingredient
              .name,
          quantity:
          scaledQuantity
              .toStringAsFixed(
            1,
          ),
          unit:
          ingredient
              .unit,
          category:
          'Ingredients',
          isChecked:
          false,
          isManual:
          false,
          createdAt:
          DateTime.now(),
        );
      },
    )
        .toList();

    await _service
        .addItemsFromRecipe(
      items: items,
    );

    await loadItems();
  }

  Future<void> toggleItem(
      String itemId,
      ) async {
    await _service
        .toggleItem(
      itemId,
    );

    await loadItems();
  }

  Future<void> deleteItem(
      String itemId,
      ) async {
    await _service
        .deleteItem(
      itemId,
    );

    await loadItems();
  }

  Future<void>
  clearCheckedItems()
  async {
    await _service
        .clearCheckedItems();

    await loadItems();
  }
}