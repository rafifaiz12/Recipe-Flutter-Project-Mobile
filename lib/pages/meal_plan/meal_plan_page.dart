import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/pages/meal_plan/widgets/day_selector_chip.dart';
import 'package:siresep/pages/meal_plan/widgets/empty_meal_card.dart';
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
    final List<Map<String, dynamic>> meals = DummyData.mealPlans
        .where(
          (meal) => meal['day'] == day && meal['mealType'] == mealType,
    )
        .toList();

    if (meals.isEmpty) {
      return null;
    }

    final String? recipeId = meals.first['recipeId'] as String?;
    if (recipeId == null) {
      return null;
    }

    return DummyData.recipeById(recipeId);
  }

  void _openShoppingListPage() {
    setState(() {
      DummyData.generateShoppingItemsFromMealPlans();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShoppingListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDay = _days[_selectedDayIndex];

    final Map<String, dynamic>? breakfast =
    _recipeFromMeal(selectedDay, 'Breakfast');
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
                child: breakfast == null
                    ? const EmptyMealCard(
                  label: 'Add breakfast',
                )
                    : MealRecipeCard(
                  title: breakfast['title'] as String,
                  imageUrl: breakfast['imageUrl'] as String,
                  subtitle:
                  '${breakfast['servings']} porsi • ${breakfast['cookTimeMinutes']} min',
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              MealSection(
                title: 'Lunch',
                child: lunch == null
                    ? const EmptyMealCard(
                  label: 'Add lunch',
                )
                    : MealRecipeCard(
                  title: lunch['title'] as String,
                  imageUrl: lunch['imageUrl'] as String,
                  subtitle:
                  '${lunch['servings']} porsi • ${lunch['cookTimeMinutes']} min',
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              MealSection(
                title: 'Dinner',
                child: dinner == null
                    ? const EmptyMealCard(
                  label: 'Add dinner',
                )
                    : MealRecipeCard(
                  title: dinner['title'] as String,
                  imageUrl: dinner['imageUrl'] as String,
                  subtitle:
                  '${dinner['servings']} porsi • ${dinner['cookTimeMinutes']} min',
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
}