import 'package:flutter/material.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/services/favorite_service.dart';

class FavoriteProvider
    extends ChangeNotifier {
  final FavoriteService
  _favoriteService =
  FavoriteService();

  List<RecipeModel>
  _favoriteRecipes = [];

  bool _isLoading = false;

  List<RecipeModel>
  get favoriteRecipes =>
      _favoriteRecipes;

  bool get isLoading =>
      _isLoading;

  int get totalFavorites =>
      _favoriteRecipes.length;

  /*
  |--------------------------------------------------------------------------
  | LOAD FAVORITES
  |--------------------------------------------------------------------------
  */

  Future<void>
  loadFavorites() async {
    _isLoading = true;

    notifyListeners();

    try {
      _favoriteRecipes =
      await _favoriteService
          .getFavoriteRecipes();
    } catch (_) {
      _favoriteRecipes = [];
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | TOGGLE FAVORITE
  |--------------------------------------------------------------------------
  */

  Future<void> toggleFavorite(
      String recipeId,
      ) async {
    await _favoriteService
        .toggleFavorite(
      recipeId,
    );

    _favoriteRecipes =
    await _favoriteService
        .getFavoriteRecipes();

    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | CHECK FAVORITE
  |--------------------------------------------------------------------------
  */

  bool isFavorite(
      String recipeId,
      ) {
    return _favoriteRecipes.any(
          (recipe) =>
      recipe.id ==
          recipeId,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | CLEAR FAVORITES
  |--------------------------------------------------------------------------
  */

  void clearFavorites() {
    _favoriteRecipes = [];

    notifyListeners();
  }
}