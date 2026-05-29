import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/core/utils/dummy_data.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/pages/meal_plan/add_meal_recipe_page.dart'
as meal_modal;

import 'package:siresep/pages/meal_plan/widgets/day_selector_chip.dart';
import 'package:siresep/pages/meal_plan/widgets/empty_meal_card.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_recipe_card.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_section.dart';

import 'package:siresep/pages/shopping_list/shopping_list_page.dart';

import 'package:siresep/providers/meal_plan_provider.dart';
import 'package:siresep/providers/shopping_list_provider.dart';

class MealPlanPage
    extends StatefulWidget {
  const MealPlanPage({
    super.key,
  });

  @override
  State<MealPlanPage>
  createState() =>
      _MealPlanPageState();
}

class _MealPlanPageState
    extends State<MealPlanPage> {
  final List<RecipeModel>
  _recipes =
      DummyData.recipes;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context
          .read<
          MealPlanProvider>()
          .loadMealPlans();
    });
  }

  Future<void>
  _openAddMealModal({
    required String mealType,
  }) async {
    final RecipeModel?
    recipe =
    await showModalBottomSheet<
        RecipeModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Colors.transparent,
      builder:
          (_) =>
          meal_modal
              .AddMealRecipePage(
            mealType: mealType,
            recipes: _recipes,
          ),
    );

    if (recipe == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    await context
        .read<
        MealPlanProvider>()
        .addMealPlan(
      mealType:
      mealType,
      recipe: recipe,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          '$mealType added to meal planner',
        ),
      ),
    );
  }

  Future<void>
  _deleteMeal({
    required String mealType,
  }) async {
    await context
        .read<
        MealPlanProvider>()
        .deleteMealPlan(
      mealType:
      mealType,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          '$mealType removed',
        ),
      ),
    );
  }

  void _openRecipeDetail(
      String recipeId,
      ) {
    Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipeId,
    );
  }

  Future<void>
  _openShoppingListPage()
  async {
    final mealProvider =
    context.read<
        MealPlanProvider>();

    final shoppingProvider =
    context.read<
        ShoppingListProvider>();

    final meals =
    mealProvider.mealPlans
        .where(
          (meal) =>
      meal.day ==
          mealProvider
              .selectedDay,
    )
        .toList();

    for (final meal
    in meals) {
      try {
        final recipe =
        _recipes.firstWhere(
              (recipe) =>
          recipe.id ==
              meal.recipeId,
        );

        await shoppingProvider
            .addRecipeIngredients(
          recipe,
          recipe.servings,
        );
      } catch (_) {}
    }

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
        const ShoppingListPage(),
      ),
    );
  }

  Widget _buildMealContent({
    required String mealType,
    required RecipeModel?
    recipe,
  }) {
    if (recipe == null) {
      return EmptyMealCard(
        label:
        'Add ${mealType.toLowerCase()}',
        onTap:
            () =>
            _openAddMealModal(
              mealType:
              mealType,
            ),
      );
    }

    return Stack(
      children: [
        MealRecipeCard(
          recipe: recipe,
          onTap:
              () =>
              _openRecipeDetail(
                recipe.id,
              ),
        ),

        Positioned(
          top:
          AppSizes.paddingM,
          right:
          AppSizes.paddingM,
          child: Material(
            color: Colors.white
                .withValues(
              alpha: 0.92,
            ),
            shape:
            const CircleBorder(),
            child: InkWell(
              onTap:
                  () =>
                  _deleteMeal(
                    mealType:
                    mealType,
                  ),
              customBorder:
              const CircleBorder(),
              child:
              const SizedBox(
                height: 42,
                width: 42,
                child: Icon(
                  Icons
                      .delete_outline,
                  color:
                  AppColors
                      .error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final provider =
    context.watch<
        MealPlanProvider>();

    final breakfast =
    provider
        .recipeFromMeal(
      mealType:
      'Breakfast',
      recipes: _recipes,
    );

    final lunch =
    provider
        .recipeFromMeal(
      mealType: 'Lunch',
      recipes: _recipes,
    );

    final dinner =
    provider
        .recipeFromMeal(
      mealType: 'Dinner',
      recipes: _recipes,
    );

    return Scaffold(
      backgroundColor:
      AppColors.background,
      body: SafeArea(
        child:
        provider.isLoading
            ? const Center(
          child:
          CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.all(
            AppSizes
                .paddingL,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                'Meal Planner',
                style:
                AppTextStyles
                    .h1
                    .copyWith(
                  fontSize:
                  30,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceS,
              ),

              Text(
                'Plan your weekly meals',
                style:
                AppTextStyles
                    .bodySecondary
                    .copyWith(
                  fontSize:
                  18,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceL,
              ),

              SizedBox(
                height: 58,
                child:
                ListView.separated(
                  scrollDirection:
                  Axis
                      .horizontal,
                  itemCount:
                  provider
                      .days
                      .length,
                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(
                    width:
                    AppSizes
                        .spaceM,
                  ),
                  itemBuilder:
                      (
                      context,
                      index,
                      ) {
                    return DaySelectorChip(
                      label:
                      provider.days[index],
                      isSelected:
                      provider.selectedDayIndex ==
                          index,
                      onTap:
                          () {
                        provider.selectDay(
                          index,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceXL,
              ),

              MealSection(
                title:
                'Breakfast',
                child:
                _buildMealContent(
                  mealType:
                  'Breakfast',
                  recipe:
                  breakfast,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceXL,
              ),

              MealSection(
                title:
                'Lunch',
                child:
                _buildMealContent(
                  mealType:
                  'Lunch',
                  recipe:
                  lunch,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceXL,
              ),

              MealSection(
                title:
                'Dinner',
                child:
                _buildMealContent(
                  mealType:
                  'Dinner',
                  recipe:
                  dinner,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceXL,
              ),

              SizedBox(
                width:
                double.infinity,
                height:
                AppSizes
                    .buttonHeight,
                child:
                ElevatedButton(
                  onPressed:
                  _openShoppingListPage,
                  child:
                  const Text(
                    'Generate Shopping List',
                  ),
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}