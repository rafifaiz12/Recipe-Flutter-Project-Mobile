import 'package:siresep/models/shopping_item_model.dart';

class ShoppingListService {
  static final List<ShoppingItemModel>
  _shoppingItems = [];

  Future<List<ShoppingItemModel>>
  getShoppingItems() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return List<ShoppingItemModel>.from(
      _shoppingItems,
    );
  }

  Future<void> addItem(
      ShoppingItemModel item,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    _shoppingItems.add(item);

    // TODO:
    // Firestore add document
  }

  Future<void> deleteItem(
      String itemId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    _shoppingItems.removeWhere(
          (item) => item.id == itemId,
    );

    // TODO:
    // Firestore delete document
  }

  Future<void> toggleItem(
      String itemId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    final index = _shoppingItems
        .indexWhere(
          (item) => item.id == itemId,
    );

    if (index == -1) {
      return;
    }

    final currentItem =
    _shoppingItems[index];

    _shoppingItems[index] =
        currentItem.copyWith(
          isChecked:
          !currentItem.isChecked,
        );

    // TODO:
    // Firestore update document
  }

  Future<void> clearCheckedItems()
  async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _shoppingItems.removeWhere(
          (item) => item.isChecked,
    );

    // TODO:
    // Firestore batch delete
  }

  Future<void>
  addItemsFromRecipe({
    required List<
        ShoppingItemModel>
    items,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _shoppingItems.addAll(items);

    // TODO:
    // Firestore batch write
  }
}