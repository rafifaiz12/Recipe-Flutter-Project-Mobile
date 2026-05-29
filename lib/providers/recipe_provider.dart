import 'package:flutter/material.dart';
import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  List<RecipeModel> _recipes = [];

  List<RecipeModel> _trendingRecipes = [];

  List<RecipeModel> _searchResults = [];

  bool _isLoading = false;

  List<RecipeModel> get recipes => _recipes;

  List<RecipeModel> get trendingRecipes =>
      _trendingRecipes;

  List<RecipeModel> get searchResults =>
      _searchResults;

  bool get isLoading => _isLoading;

  Future<void> loadRecipes() async {
    _isLoading = true;

    notifyListeners();

    try {
      _recipes = await _recipeService.getRecipes();

      _trendingRecipes =
      await _recipeService.getTrendingRecipes();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];

      notifyListeners();

      return;
    }

    _searchResults =
    await _recipeService.searchRecipes(query);

    notifyListeners();
  }
}