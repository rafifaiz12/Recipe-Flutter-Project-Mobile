import 'dart:async';

import 'package:flutter/material.dart';

import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/services/recipe_detail_service.dart';

class RecipeDetailProvider extends ChangeNotifier {
  final RecipeDetailService _recipeDetailService =
  RecipeDetailService();

  RecipeModel? _recipe;

  bool _isLoading = false;

  String? _errorMessage;

  int _selectedServings = 1;

  StreamSubscription<RecipeModel?>?
  _recipeSubscription;

  RecipeModel? get recipe => _recipe;

  bool get isLoading => _isLoading;

  String? get errorMessage =>
      _errorMessage;

  int get selectedServings =>
      _selectedServings;

  /*
  |--------------------------------------------------------------------------
  | LOAD RECIPE
  |--------------------------------------------------------------------------
  */

  Future<void> loadRecipe(
      String recipeId,
      ) async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      _recipe =
      await _recipeDetailService
          .getRecipeById(
        recipeId,
      );

      final recipeServings =
          _recipe?.servings ?? 1;

      _selectedServings =
      recipeServings <= 0
          ? 1
          : recipeServings;

      listenRecipe(recipeId);
    } catch (e) {
      _errorMessage =
          e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | REALTIME LISTENER
  |--------------------------------------------------------------------------
  */

  void listenRecipe(
      String recipeId,
      ) {
    _recipeSubscription?.cancel();

    _recipeSubscription =
        _recipeDetailService
            .getRecipeStreamById(
          recipeId,
        ).listen(
              (recipe) {
            if (recipe == null) {
              return;
            }

            _recipe = recipe;

            notifyListeners();
          },
        );
  }

  /*
  |--------------------------------------------------------------------------
  | SERVINGS
  |--------------------------------------------------------------------------
  */

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

  /*
  |--------------------------------------------------------------------------
  | INGREDIENT SCALING
  |--------------------------------------------------------------------------
  */

  double scaledQuantity(
      double quantity,
      ) {
    final recipeServings =
        _recipe?.servings ?? 1;

    final baseServings =
    recipeServings <= 0
        ? 1
        : recipeServings;

    return quantity *
        _selectedServings /
        baseServings;
  }

  /*
  |--------------------------------------------------------------------------
  | FORMAT QUANTITY
  |--------------------------------------------------------------------------
  */

  String formatQuantity(
      double value,
      ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value.toString();
  }

  /*
  |--------------------------------------------------------------------------
  | FORMAT REVIEW DATE
  |--------------------------------------------------------------------------
  */

  String formatReviewDate(
      DateTime date,
      ) {
    final day =
    date.day
        .toString()
        .padLeft(2, '0');

    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    final year =
    date.year.toString();

    return '$day/$month/$year';
  }

  /*
  |--------------------------------------------------------------------------
  | CLEAR
  |--------------------------------------------------------------------------
  */

  void clear() {
    _recipe = null;

    _errorMessage = null;

    _selectedServings = 1;

    notifyListeners();
  }

  @override
  void dispose() {
    _recipeSubscription?.cancel();

    super.dispose();
  }
}