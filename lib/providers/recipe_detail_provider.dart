import 'package:flutter/material.dart';

import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/models/review_model.dart';

import 'package:siresep/services/recipe_detail_service.dart';

class RecipeDetailProvider
    extends ChangeNotifier {
  final RecipeDetailService
  _service =
  RecipeDetailService();

  RecipeModel? _recipe;

  List<ReviewModel> _reviews = [];

  bool _isLoading = false;

  int _selectedServings = 1;

  RecipeModel? get recipe => _recipe;

  List<ReviewModel> get reviews =>
      _reviews;

  bool get isLoading => _isLoading;

  int get selectedServings =>
      _selectedServings;

  Future<void> loadRecipe(
      String recipeId,
      ) async {
    _isLoading = true;

    notifyListeners();

    try {
      final recipe =
      await _service.getRecipe(
        recipeId,
      );

      if (recipe != null) {
        _recipe = recipe;

        _selectedServings =
            recipe.servings;
      }

      _reviews =
      await _service.getReviews(
        recipeId,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> addReview({
    required int rating,
    required String comment,
  }) async {
    if (_recipe == null) {
      return;
    }

    await _service.addReview(
      recipeId: _recipe!.id,
      rating: rating,
      comment: comment,
    );

    await loadRecipe(_recipe!.id);
  }

  void increaseServings() {
    _selectedServings++;

    notifyListeners();
  }

  void decreaseServings() {
    if (_selectedServings <= 1) {
      return;
    }

    _selectedServings--;

    notifyListeners();
  }

  double scaledQuantity(
      double baseQuantity,
      ) {
    if (_recipe == null) {
      return baseQuantity;
    }

    return (baseQuantity /
        _recipe!.servings) *
        _selectedServings;
  }

  String formatQuantity(
      double value,
      ) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(1)
        .replaceAll('.0', '');
  }

  String formatReviewDate(
      DateTime date,
      ) {
    final difference =
        DateTime.now()
            .difference(date)
            .inDays;

    if (difference <= 0) {
      return 'Today';
    }

    if (difference == 1) {
      return '1 day ago';
    }

    if (difference < 7) {
      return '$difference days ago';
    }

    if (difference < 14) {
      return '1 week ago';
    }

    final week =
    (difference / 7).floor();

    return '$week weeks ago';
  }
}