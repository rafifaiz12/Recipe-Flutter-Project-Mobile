import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
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

  final List<Map<String, dynamic>> _weeklyPlans = [
    {
      'day': 'Mon',
      'subtitle': 'Plan your weekly meals',
      'breakfast': null,
      'lunch': {
        'title': 'Mediterranean Bowl',
        'duration': '20 min',
        'portion': '2 porsi',
        'image':
        'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1200&q=80',
      },
      'dinner': {
        'title': 'Creamy Pasta Carbonara',
        'duration': '25 min',
        'portion': '2 porsi',
        'image':
        'https://images.unsplash.com/photo-1516100882582-96c3a05fe590?auto=format&fit=crop&w=1200&q=80',
      },
    },
    {
      'day': 'Tue',
      'subtitle': 'Plan your weekly meals',
      'breakfast': {
        'title': 'Avocado Toast',
        'duration': '10 min',
        'portion': '1 porsi',
        'image':
        'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=1200&q=80',
      },
      'lunch': null,
      'dinner': {
        'title': 'Grilled Chicken Salad',
        'duration': '18 min',
        'portion': '2 porsi',
        'image':
        'https://images.unsplash.com/photo-1546793665-c74683f339c1?auto=format&fit=crop&w=1200&q=80',
      },
    },
    {
      'day': 'Wed',
      'subtitle': 'Plan your weekly meals',
      'breakfast': null,
      'lunch': {
        'title': 'Chicken Katsu Bowl',
        'duration': '30 min',
        'portion': '2 porsi',
        'image':
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1200&q=80',
      },
      'dinner': null,
    },
    {
      'day': 'Thu',
      'subtitle': 'Plan your weekly meals',
      'breakfast': {
        'title': 'Fruit Yogurt Bowl',
        'duration': '8 min',
        'portion': '1 porsi',
        'image':
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=1200&q=80',
      },
      'lunch': null,
      'dinner': null,
    },
    {
      'day': 'Fri',
      'subtitle': 'Plan your weekly meals',
      'breakfast': null,
      'lunch': null,
      'dinner': {
        'title': 'Salmon Teriyaki',
        'duration': '22 min',
        'portion': '2 porsi',
        'image':
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=1200&q=80',
      },
    },
  ];

  Map<String, dynamic> get _selectedPlan => _weeklyPlans[_selectedDayIndex];

  void _openShoppingListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShoppingListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? breakfast =
    _selectedPlan['breakfast'] as Map<String, dynamic>?;
    final Map<String, dynamic>? lunch =
    _selectedPlan['lunch'] as Map<String, dynamic>?;
    final Map<String, dynamic>? dinner =
    _selectedPlan['dinner'] as Map<String, dynamic>?;

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
                _selectedPlan['subtitle'] as String,
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
                  imageUrl: breakfast['image'] as String,
                  subtitle:
                  '${breakfast['portion']} • ${breakfast['duration']}',
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
                  imageUrl: lunch['image'] as String,
                  subtitle:
                  '${lunch['portion']} • ${lunch['duration']}',
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
                  imageUrl: dinner['image'] as String,
                  subtitle:
                  '${dinner['portion']} • ${dinner['duration']}',
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