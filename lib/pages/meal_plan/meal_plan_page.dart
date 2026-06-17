import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/pages/meal_plan/add_meal_recipe_page.dart'
as meal_modal;

import 'package:siresep/pages/meal_plan/widgets/day_selector_chip.dart';
import 'package:siresep/pages/meal_plan/widgets/empty_meal_card.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_recipe_card.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_section.dart';

import 'package:siresep/pages/shopping_list/shopping_list_page.dart';

import 'package:siresep/providers/recipe_provider.dart';
import 'package:siresep/providers/meal_plan_provider.dart';
import 'package:siresep/providers/shopping_list_provider.dart';
import 'package:siresep/providers/meal_plan_template_provider.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String _recipeNameFromId(String? recipeId, List<RecipeModel> recipes) {
    if (recipeId == null || recipeId.trim().isEmpty) {
      return '-';
    }

    try {
      final recipe = recipes.firstWhere((recipe) => recipe.id == recipeId);

      return recipe.title;
    } catch (_) {
      return 'Recipe tidak ditemukan';
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<MealPlanProvider>().loadMealPlans();
    });
  }

  Future<bool> _showApplyTemplateDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Use Template'),
          content: const Text(
            'This template will fill your weekly meal planner.',
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Use'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ) ??
        false;
  }

  void _showTemplatePreview(dynamic template, List<RecipeModel> recipes) {
    const orderedDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(template.name),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: orderedDays.map((day) {
                  final meals = template.mealPlan[day] ?? {};

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Breakfast : ${_recipeNameFromId(meals['Breakfast'], recipes)}',
                        ),

                        Text(
                          'Lunch : ${_recipeNameFromId(meals['Lunch'], recipes)}',
                        ),

                        Text(
                          'Dinner : ${_recipeNameFromId(meals['Dinner'], recipes)}',
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemplateSection() {
    return Consumer2<MealPlanTemplateProvider, MealPlanProvider>(
      builder: (context, templateProvider, mealPlanProvider, _) {
        if (templateProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (templateProvider.errorMessage != null) {
          return Text(
            'Gagal memuat template meal plan',
            style: AppTextStyles.bodySecondary.copyWith(color: AppColors.error),
          );
        }

        if (templateProvider.templates.isEmpty) {
          return Text(
            'There is no template yet.',
            style: AppTextStyles.bodySecondary,
          );
        }

        final recipes = context.read<RecipeProvider>().recipes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Template', style: AppTextStyles.h2),

            const SizedBox(height: AppSizes.spaceM),

            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: templateProvider.templates.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.spaceM),
                itemBuilder: (context, index) {
                  final template = templateProvider.templates[index];

                  return Container(
                    width: 280,
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          template.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  _showTemplatePreview(template, recipes);
                                },
                                child: const Text('Preview'),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () async {
                                  final confirmed =
                                  await _showApplyTemplateDialog();

                                  if (!confirmed) {
                                    return;
                                  }

                                  try {
                                    await mealPlanProvider.applyTemplate(
                                      template,
                                    );

                                    if (!context.mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Template succesfully used.',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Gagal menggunakan template: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Use'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  int _countTemplateMeals(Map<String, Map<String, String?>> mealPlan) {
    int count = 0;

    for (final dayMeals in mealPlan.values) {
      for (final recipeId in dayMeals.values) {
        if (recipeId != null && recipeId.trim().isNotEmpty) {
          count++;
        }
      }
    }

    return count;
  }

  Future<void> _openAddMealModal({required String mealType}) async {
    final recipes = context.read<RecipeProvider>().recipes;
    final RecipeModel? recipe = await showModalBottomSheet<RecipeModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          meal_modal.AddMealRecipePage(mealType: mealType, recipes: recipes),
    );

    if (recipe == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    await context.read<MealPlanProvider>().addMealPlan(
      mealType: mealType,
      recipe: recipe,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$mealType added to meal planner')));
  }

  Future<void> _deleteMeal({required String mealType}) async {
    await context.read<MealPlanProvider>().deleteMealPlan(mealType: mealType);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$mealType removed')));
  }

  void _openRecipeDetail(String recipeId) {
    Navigator.pushNamed(context, AppRoutes.recipeDetail, arguments: recipeId);
  }

  Future<void> _openShoppingListPage() async {
    final mealProvider = context.read<MealPlanProvider>();

    final shoppingProvider = context.read<ShoppingListProvider>();

    final recipes = context.read<RecipeProvider>().recipes;

    final meals = mealProvider.mealPlans
        .where((meal) => meal.day == mealProvider.selectedDay)
        .toList();

    for (final meal in meals) {
      try {
        final recipe = recipes.firstWhere(
              (recipe) => recipe.id == meal.recipeId,
        );

        await shoppingProvider.addRecipeIngredients(recipe, recipe.servings);
      } catch (_) {}
    }

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShoppingListPage(
          showBackButton: true,
        ),
      ),
    );
  }

  Widget _buildMealContent({
    required String mealType,
    required RecipeModel? recipe,
  }) {
    if (recipe == null) {
      return EmptyMealCard(
        label: 'Add ${mealType.toLowerCase()}',
        onTap: () => _openAddMealModal(mealType: mealType),
      );
    }

    return Stack(
      children: [
        MealRecipeCard(
          recipe: recipe,
          onTap: () => _openRecipeDetail(recipe.id),
        ),

        Positioned(
          top: AppSizes.paddingM,
          right: AppSizes.paddingM,
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _deleteMeal(mealType: mealType),
              customBorder: const CircleBorder(),
              child: const SizedBox(
                height: 42,
                width: 42,
                child: Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealPlanProvider>();

    final recipeProvider = context.watch<RecipeProvider>();

    final recipes = recipeProvider.recipes;

    final breakfast = provider.recipeFromMeal(
      mealType: 'Breakfast',
      recipes: recipes,
    );

    final lunch = provider.recipeFromMeal(mealType: 'Lunch', recipes: recipes);

    final dinner = provider.recipeFromMeal(
      mealType: 'Dinner',
      recipes: recipes,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Planner',
                    style: AppTextStyles.h1.copyWith(fontSize: 30),
                  ),

                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _showClearAllMealDialog,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 42,
                        height: 42,
                        child: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceS),

              Text(
                'Plan your weekly meals',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 18),
              ),

              const SizedBox(height: AppSizes.spaceL),

              _buildTemplateSection(),

              const SizedBox(height: AppSizes.spaceL),

              SizedBox(
                height: 58,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.days.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.spaceM),
                  itemBuilder: (context, index) {
                    return DaySelectorChip(
                      label: provider.days[index],
                      isSelected: provider.selectedDayIndex == index,
                      onTap: () {
                        provider.selectDay(index);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),

              MealSection(
                title: 'Breakfast',
                child: _buildMealContent(
                  mealType: 'Breakfast',
                  recipe: breakfast,
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),

              MealSection(
                title: 'Lunch',
                child: _buildMealContent(
                  mealType: 'Lunch',
                  recipe: lunch,
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),

              MealSection(
                title: 'Dinner',
                child: _buildMealContent(
                  mealType: 'Dinner',
                  recipe: dinner,
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),

              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: _openShoppingListPage,
                  child: const Text('Generate Shopping List'),
                ),
              ),

              const SizedBox(height: AppSizes.spaceL),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showClearAllMealDialog() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete All Meal Plan'),
              content: const Text('All weekly meal plan will be deleted.'),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) {
      return;
    }

    await context.read<MealPlanProvider>().clearAllMeals();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All meal plan successfully deleted.')),
    );
  }
}
