import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/models/recipe_model.dart';

class RecipeService {
  Future<List<RecipeModel>> getRecipes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return DummyData.recipes;
  }

  Future<List<RecipeModel>> getTrendingRecipes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return DummyData.recipes
        .where((recipe) => recipe.isTrending)
        .toList();
  }

  Future<List<RecipeModel>> searchRecipes(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final lowercaseQuery = query.toLowerCase();

    return DummyData.recipes.where((recipe) {
      return recipe.title
          .toLowerCase()
          .contains(lowercaseQuery);
    }).toList();
  }

  Future<RecipeModel?> getRecipeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return DummyData.recipes.firstWhere(
            (recipe) => recipe.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}