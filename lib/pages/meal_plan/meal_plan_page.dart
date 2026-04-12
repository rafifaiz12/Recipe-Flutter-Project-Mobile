import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/pages/meal_plan/add_meal_recipe_page.dart'
    as meal_modal;
import 'package:siresep/pages/meal_plan/widgets/day_selector_chip.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_recipe_card.dart';
import 'package:siresep/pages/meal_plan/widgets/meal_section.dart';
import 'package:siresep/pages/shopping_list/shopping_list_page.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  int _selectedDayIndex = 0;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  Map<String, dynamic>? _recipeFromMeal(String day, String mealType) {
    final Map<String, dynamic>? meal = DummyData.mealPlanByDayAndType(
      day,
      mealType,
    );

    if (meal == null) {
      return null;
    }

    final String? recipeId = meal['recipeId'] as String?;
    if (recipeId == null) {
      return null;
    }

    return DummyData.recipeById(recipeId);
  }

  Future<void> _openAddMealModal(String mealType) async {
    final String selectedDay = _days[_selectedDayIndex];

    final String? recipeId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => meal_modal.AddMealRecipePage(mealType: mealType),
    );

    if (recipeId == null) {
      return;
    }

    setState(() {
      DummyData.upsertMealPlan(
        day: selectedDay,
        mealType: mealType,
        recipeId: recipeId,
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$mealType added to meal planner')));
  }

  void _openRecipeDetail(String recipeId) {
    Navigator.pushNamed(context, AppRoutes.recipeDetail, arguments: recipeId);
  }

  void _deleteMeal(String mealType) {
    final String selectedDay = _days[_selectedDayIndex];

    setState(() {
      DummyData.removeMealPlan(day: selectedDay, mealType: mealType);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$mealType removed from meal planner')),
    );
  }

  void _openShoppingListPage() {
    final String selectedDay = _days[_selectedDayIndex];

    setState(() {
      DummyData.generateShoppingItemsFromMealPlans(day: selectedDay);
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShoppingListPage()),
    );
  }

  Widget _buildEmptyMealCard({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 52,
            horizontal: AppSizes.paddingL,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Column(
            children: [
              const Icon(Icons.add, size: 44, color: AppColors.textSecondary),
              const SizedBox(height: AppSizes.spaceM),
              Text(
                label,
                style: AppTextStyles.bodySecondary.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealContent({
    required String mealType,
    required Map<String, dynamic>? recipe,
  }) {
    if (recipe == null) {
      return _buildEmptyMealCard(
        label: 'Add ${mealType.toLowerCase()}',
        onTap: () => _openAddMealModal(mealType),
      );
    }

    return Stack(
      children: [
        MealRecipeCard(
          title: recipe['title'] as String? ?? '',
          imageUrl: recipe['imageUrl'] as String? ?? '',
          subtitle:
              '${recipe['servings']} porsi • ${recipe['cookTimeMinutes']} min',
          onTap: () => _openRecipeDetail(recipe['id'] as String),
        ),
        Positioned(
          top: AppSizes.paddingM,
          right: AppSizes.paddingM,
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _deleteMeal(mealType),
              customBorder: const CircleBorder(),
              child: const SizedBox(
                height: 42,
                width: 42,
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: AppSizes.iconM,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDay = _days[_selectedDayIndex];

    final Map<String, dynamic>? breakfast = _recipeFromMeal(
      selectedDay,
      'Breakfast',
    );
    final Map<String, dynamic>? lunch = _recipeFromMeal(selectedDay, 'Lunch');
    final Map<String, dynamic>? dinner = _recipeFromMeal(selectedDay, 'Dinner');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meal Planner',
                style: AppTextStyles.h1.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Plan your weekly meals',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 18),
              ),
              const SizedBox(height: AppSizes.spaceL),
              SizedBox(
                height: 58,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSizes.spaceM),
                  itemBuilder: (context, index) {
                    return DaySelectorChip(
                      label: _days[index],
                      isSelected: _selectedDayIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
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
                child: _buildMealContent(mealType: 'Lunch', recipe: lunch),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              MealSection(
                title: 'Dinner',
                child: _buildMealContent(mealType: 'Dinner', recipe: dinner),
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
}
