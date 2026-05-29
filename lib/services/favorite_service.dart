import 'package:siresep/core/utils/dummy_data.dart';

import 'package:siresep/models/favorite_model.dart';
import 'package:siresep/models/recipe_model.dart';

class FavoriteService {
  Future<List<RecipeModel>> getFavoriteRecipes() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final favoriteRecipeIds =
    DummyData.favorites
        .map(
          (favorite) => favorite.recipeId,
    )
        .toList();

    return DummyData.recipes
        .where(
          (recipe) =>
          favoriteRecipeIds.contains(recipe.id),
    )
        .toList();
  }

  Future<bool> isFavorite(
      String recipeId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    return DummyData.favorites.any(
          (favorite) =>
      favorite.recipeId == recipeId,
    );
  }

  Future<void> toggleFavorite(
      String recipeId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    final existingIndex =
    DummyData.favorites.indexWhere(
          (favorite) =>
      favorite.recipeId == recipeId,
    );

    if (existingIndex != -1) {
      DummyData.favorites.removeAt(
        existingIndex,
      );

      return;
    }

    DummyData.favorites.add(
      FavoriteModel(
        id:
        'favorite_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'temporary_user',
        recipeId: recipeId,
        createdAt: DateTime.now(),
      ),
    );
  }
}