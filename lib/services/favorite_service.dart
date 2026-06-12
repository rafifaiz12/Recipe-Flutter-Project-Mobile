import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:siresep/models/favorite_model.dart';
import 'package:siresep/models/recipe_model.dart';

class FavoriteService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>
  get _favoritesCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
  }

  CollectionReference<Map<String, dynamic>>
  get _recipesCollection {
    return _firestore.collection(
      'recipes',
    );
  }

  Future<List<RecipeModel>>
  getFavoriteRecipes() async {
    final favoriteSnapshot =
    await _favoritesCollection.get();

    if (favoriteSnapshot.docs.isEmpty) {
      return [];
    }

    final favoriteRecipeIds =
    favoriteSnapshot.docs
        .map(
          (doc) =>
      doc.data()['recipeId']
      as String,
    )
        .toList();

    final recipesSnapshot =
    await _recipesCollection.get();

    return recipesSnapshot.docs
        .where(
          (doc) => favoriteRecipeIds.contains(doc.id),
    )
        .map(
          (doc) => RecipeModel.fromFirestore(doc),
    )
        .toList();
  }

  Future<bool> isFavorite(
      String recipeId,
      ) async {
    final snapshot =
    await _favoritesCollection
        .where(
      'recipeId',
      isEqualTo: recipeId,
    )
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> toggleFavorite(
      String recipeId,
      ) async {
    final existingFavorite =
    await _favoritesCollection
        .where(
      'recipeId',
      isEqualTo: recipeId,
    )
        .limit(1)
        .get();

    if (existingFavorite.docs.isNotEmpty) {
      await existingFavorite
          .docs
          .first
          .reference
          .delete();

      return;
    }

    final favoriteId =
        'favorite_${DateTime.now().millisecondsSinceEpoch}';

    final user =
    FirebaseAuth.instance.currentUser!;

    final favorite = FavoriteModel(
      id: favoriteId,
      userId: user.uid,
      recipeId: recipeId,
      createdAt: DateTime.now(),
    );

    await _favoritesCollection
        .doc(favoriteId)
        .set(
      favorite.toMap(),
    );
  }

  Future<void> removeFavorite(
      String recipeId,
      ) async {
    final snapshot =
    await _favoritesCollection
        .where(
      'recipeId',
      isEqualTo: recipeId,
    )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    await snapshot
        .docs
        .first
        .reference
        .delete();
  }

  Future<List<FavoriteModel>>
  getFavorites() async {
    final snapshot =
    await _favoritesCollection.get();

    return snapshot.docs
        .map(
          (doc) =>
          FavoriteModel.fromMap(
            doc.data(),
          ),
    )
        .toList();
  }
}