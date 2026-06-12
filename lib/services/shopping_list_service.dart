import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/shopping_item_model.dart';

class ShoppingListService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>>
  get _shoppingCollection =>
      _firestore
          .collection('users')
          .doc(_userId)
          .collection('shopping_items');

  Future<List<ShoppingItemModel>>
  getShoppingItems() async {
    final snapshot =
    await _shoppingCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          ShoppingItemModel.fromFirestore(
            doc,
          ),
    )
        .toList();
  }

  Future<void> addItem(
      ShoppingItemModel item,
      ) async {
    await _shoppingCollection
        .doc(item.id)
        .set(item.toFirestore());
        debugPrint(
          'SHOPPING ITEM SAVED',
        );
  }

  Future<void> deleteItem(
      String itemId,
      ) async {
    await _shoppingCollection
        .doc(itemId)
        .delete();
  }

  Future<void> toggleItem(
      String itemId,
      ) async {
    final doc =
    await _shoppingCollection
        .doc(itemId)
        .get();

    if (!doc.exists) {
      return;
    }

    final item =
    ShoppingItemModel.fromFirestore(
      doc,
    );

    await _shoppingCollection
        .doc(itemId)
        .update({
      'isChecked':
      !item.isChecked,
    });
  }

  Future<void> clearCheckedItems()
  async {
    final snapshot =
    await _shoppingCollection
        .where(
      'isChecked',
      isEqualTo: true,
    )
        .get();

    final batch =
    _firestore.batch();

    for (final doc
    in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void>
  addItemsFromRecipe({
    required List<
        ShoppingItemModel>
    items,
  }) async {
    final batch =
    _firestore.batch();

    for (final item in items) {
      final docRef =
      _shoppingCollection.doc(
        item.id,
      );

      batch.set(
        docRef,
        item.toFirestore(),
      );
    }

    await batch.commit();
  }
}