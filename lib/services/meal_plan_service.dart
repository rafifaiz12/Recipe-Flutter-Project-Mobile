import 'package:siresep/models/meal_plan_model.dart';

class MealPlanService {
  static final List<MealPlanModel>
  _mealPlans = [];

  Future<List<MealPlanModel>>
  getMealPlans() async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    return List<MealPlanModel>.from(
      _mealPlans,
    );
  }

  Future<void> addMealPlan(
      MealPlanModel mealPlan,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _mealPlans.removeWhere(
          (meal) {
        return meal.day ==
            mealPlan.day &&
            meal.mealType ==
                mealPlan.mealType;
      },
    );

    _mealPlans.add(
      mealPlan,
    );
  }

  Future<void> deleteMealPlan({
    required String day,
    required String mealType,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _mealPlans.removeWhere(
          (meal) {
        return meal.day ==
            day &&
            meal.mealType ==
                mealType;
      },
    );
  }

  Future<void> clearDayMeals(
      String day,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _mealPlans.removeWhere(
          (meal) =>
      meal.day == day,
    );
  }
}