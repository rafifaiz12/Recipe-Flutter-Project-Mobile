import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:siresep/models/meal_plan_model.dart';
import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/services/meal_plan_service.dart';
import 'package:siresep/models/meal_plan_template_model.dart';

class MealPlanProvider extends ChangeNotifier {
  MealPlanProvider() {
    loadMealPlans();
  }
  final MealPlanService _service = MealPlanService();

  List<MealPlanModel> _mealPlans = [];

  bool _isLoading = false;

  int _selectedDayIndex = 0;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  List<MealPlanModel> get mealPlans => _mealPlans;

  bool get isLoading => _isLoading;

  int get selectedDayIndex => _selectedDayIndex;

  List<String> get days => _days;

  int get totalPlannedMeals {
    return _mealPlans.length;
  }

  String get selectedDay => _days[_selectedDayIndex];

  Future<void> loadMealPlans() async {
    _isLoading = true;

    notifyListeners();

    try {
      _mealPlans = await _service.getMealPlans();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void selectDay(int index) {
    _selectedDayIndex = index;

    notifyListeners();
  }

  MealPlanModel? mealByType(String mealType) {
    try {
      return _mealPlans.firstWhere((meal) {
        return meal.day == selectedDay && meal.mealType == mealType;
      });
    } catch (_) {
      return null;
    }
  }

  RecipeModel? recipeFromMeal({
    required String mealType,
    required List<RecipeModel> recipes,
  }) {
    final meal = mealByType(mealType);

    if (meal == null) {
      return null;
    }

    try {
      return recipes.firstWhere((recipe) => recipe.id == meal.recipeId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addMealPlan({
    required String mealType,
    required RecipeModel recipe,
  }) async {
    final mealPlan = MealPlanModel(
      id: '${selectedDay}_$mealType',
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      day: selectedDay,
      mealType: mealType,
      recipeId: recipe.id,
      createdAt: DateTime.now(),
    );

    await _service.addMealPlan(mealPlan);

    await loadMealPlans();
  }

  Future<void> deleteMealPlan({required String mealType}) async {
    await _service.deleteMealPlan(day: selectedDay, mealType: mealType);

    await loadMealPlans();
  }

  Future<void> clearDayMeals() async {
    await _service.clearDayMeals(selectedDay);

    await loadMealPlans();
  }

  Future<void> applyTemplate(MealPlanTemplateModel template) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    for (final dayEntry in template.mealPlan.entries) {
      final day = dayEntry.key;

      for (final mealEntry in dayEntry.value.entries) {
        final mealType = mealEntry.key;
        final recipeId = mealEntry.value;

        if (recipeId == null || recipeId.trim().isEmpty) {
          continue;
        }

        final mealPlan = MealPlanModel(
          id: '${day}_$mealType',
          userId: userId,
          day: day,
          mealType: mealType,
          recipeId: recipeId,
          createdAt: DateTime.now(),
        );

        await _service.addMealPlan(mealPlan);
      }
    }

    await loadMealPlans();
  }

  Future<void> clearAllMeals() async {
    for (final day in _days) {
      await _service.clearDayMeals(day);
    }

    await loadMealPlans();
  }
}
