import 'package:flutter/material.dart';
import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/services/recipe_detail_service.dart';

class RecipeDetailProvider extends ChangeNotifier {
  final RecipeDetailService _recipeDetailService = RecipeDetailService();

  RecipeModel? _recipe;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedServings = 1;

  RecipeModel? get recipe => _recipe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedServings => _selectedServings;

  Future<void> loadRecipe(String recipeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipe = await _recipeDetailService.getRecipeById(recipeId);
      _selectedServings = _recipe?.servings == 0 ? 1 : _recipe?.servings ?? 1;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void increaseServings() {
    _selectedServings++;
    notifyListeners();
  }

  void decreaseServings() {
    if (_selectedServings <= 1) return;

    _selectedServings--;
    notifyListeners();
  }

  double scaledQuantity(double quantity) {
    final baseServings = _recipe?.servings == 0 ? 1 : _recipe?.servings ?? 1;
    return quantity * _selectedServings / baseServings;
  }

  String formatQuantity(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  Future<void> addReview({required int rating, required String comment}) async {
    // Review Firestore bisa kita integrasikan pada tahap berikutnya.
    // Method ini dibiarkan agar UI lama tidak error.
  }

  String formatReviewDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
