import 'package:flutter/material.dart';
import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  List<RecipeModel> _recipes = [];

  List<RecipeModel> _trendingRecipes = [];

  List<RecipeModel> _searchResults = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<RecipeModel> get recipes => _recipes;

  List<RecipeModel> get trendingRecipes => _trendingRecipes;

  List<RecipeModel> get searchResults => _searchResults;

  List<RecipeModel> get recommendedRecipes {
    final candidates = _recipes.where((recipe) => !recipe.isTrending).toList();

    candidates.sort((a, b) {
      final scoreA = a.ratingAverage * a.reviewCount;

      final scoreB = b.ratingAverage * b.reviewCount;

      return scoreB.compareTo(scoreA);
    });

    return candidates.take(5).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _recipeService.getRecipes();
      _trendingRecipes = await _recipeService.getTrendingRecipes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchRecipes(String query) {
    if (query.trim().isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _recipes.where((recipe) {
        return recipe.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
