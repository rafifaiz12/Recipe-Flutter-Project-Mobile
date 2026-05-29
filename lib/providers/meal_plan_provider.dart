import 'package:flutter/material.dart';

import 'package:siresep/models/meal_plan_model.dart';
import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/services/meal_plan_service.dart';

class MealPlanProvider
    extends ChangeNotifier {
  final MealPlanService
  _service =
  MealPlanService();

  List<MealPlanModel>
  _mealPlans = [];

  bool _isLoading = false;

  int _selectedDayIndex = 0;

  final List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  List<MealPlanModel>
  get mealPlans => _mealPlans;

  bool get isLoading => _isLoading;

  int get selectedDayIndex =>
      _selectedDayIndex;

  List<String> get days => _days;

  int get totalPlannedMeals {
    return _mealPlans.length;
  }

  String get selectedDay =>
      _days[_selectedDayIndex];

  Future<void> loadMealPlans()
  async {
    _isLoading = true;

    notifyListeners();

    try {
      _mealPlans =
      await _service
          .getMealPlans();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void selectDay(int index) {
    _selectedDayIndex = index;

    notifyListeners();
  }

  MealPlanModel? mealByType(
      String mealType,
      ) {
    try {
      return _mealPlans.firstWhere(
            (meal) {
          return meal.day ==
              selectedDay &&
              meal.mealType ==
                  mealType;
        },
      );
    } catch (_) {
      return null;
    }
  }

  RecipeModel? recipeFromMeal({
    required String mealType,
    required List<RecipeModel>
    recipes,
  }) {
    final meal =
    mealByType(mealType);

    if (meal == null) {
      return null;
    }

    try {
      return recipes.firstWhere(
            (recipe) =>
        recipe.id ==
            meal.recipeId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> addMealPlan({
    required String mealType,
    required RecipeModel recipe,
  }) async {
    final mealPlan =
    MealPlanModel(
      id:
      '${selectedDay}_$mealType',
      userId: 'temporary_user',
      day: selectedDay,
      mealType: mealType,
      recipeId: recipe.id,
      createdAt: DateTime.now(),
    );

    await _service.addMealPlan(
      mealPlan,
    );

    await loadMealPlans();
  }

  Future<void> deleteMealPlan({
    required String mealType,
  }) async {
    await _service.deleteMealPlan(
      day: selectedDay,
      mealType: mealType,
    );

    await loadMealPlans();
  }

  Future<void> clearDayMeals()
  async {
    await _service.clearDayMeals(
      selectedDay,
    );

    await loadMealPlans();
  }
}