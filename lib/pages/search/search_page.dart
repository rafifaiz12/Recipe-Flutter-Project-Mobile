import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String? _selectedCookingTime;
  String? _selectedCourseType;
  String? _selectedCuisine;

  final List<String> _cookingTimeOptions = const [
    '<15 minutes',
    '15 minutes - 1 hours',
    '>1 hours',
  ];

  final List<String> _courseTypeOptions = const [
    'Breakfas',
    'Lunch',
    'Diner',
  ];

  final List<String> _cuisineOptions = const ['Indonesia', 'Asian', 'Western'];

  static const Map<String, String> _courseTypeToCategoryName = {
    'Sarapan': 'Breakfast',
    'Makan Siang': 'Lunch',
    'Makan Malam': 'Dinner',
    'Dessert': 'Dessert',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRecipes {
    final recipes = DummyData.recipes.where((recipe) {
      final title = (recipe['title'] as String? ?? '').toLowerCase();
      final description = (recipe['description'] as String? ?? '')
          .toLowerCase();
      final query = _searchQuery.toLowerCase();

      final matchesQuery =
          query.isEmpty || title.contains(query) || description.contains(query);

      final cookTime = (recipe['cookTimeMinutes'] as int?) ?? 0;
      final matchesCookingTime =
          _selectedCookingTime == null ||
              (_selectedCookingTime == '<15 menit' && cookTime < 15) ||
              (_selectedCookingTime == '15 menit - 1 jam' &&
                  cookTime >= 15 &&
                  cookTime <= 60) ||
              (_selectedCookingTime == '>1 jam' && cookTime > 60);

      final categoryName = recipe['categoryName'] as String? ?? '';
      final selectedCategory =
          _courseTypeToCategoryName[_selectedCourseType] ?? '';
      final matchesCourseType =
          _selectedCourseType == null || categoryName == selectedCategory;

      final cuisine = recipe['cuisine'] as String? ?? '';
      final matchesCuisine =
          _selectedCuisine == null || cuisine == _selectedCuisine;

      return matchesQuery &&
          matchesCookingTime &&
          matchesCourseType &&
          matchesCuisine;
    }).toList();

    recipes.sort((a, b) {
      final aTrending = a['isTrending'] == true ? 1 : 0;
      final bTrending = b['isTrending'] == true ? 1 : 0;
      return bTrending.compareTo(aTrending);
    });

    return recipes;
  }

  void _goToRecipeDetail(String recipeId) {
    Navigator.pushNamed(context, AppRoutes.recipeDetail, arguments: recipeId);
  }

  void _toggleCookingTime(String value) {
    setState(() {
      _selectedCookingTime = _selectedCookingTime == value ? null : value;
    });
  }

  void _toggleCourseType(String value) {
    setState(() {
      _selectedCourseType = _selectedCourseType == value ? null : value;
    });
  }

  void _toggleCuisine(String value) {
    setState(() {
      _selectedCuisine = _selectedCuisine == value ? null : value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = _filteredRecipes;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Recipes',
                style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spaceL),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Search recipes or ingredients...',
                  hintStyle: AppTextStyles.bodySecondary,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                    vertical: AppSizes.paddingM,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              _FilterSection(
                title: 'Cooking Time',
                options: _cookingTimeOptions,
                selectedValue: _selectedCookingTime,
                onSelected: _toggleCookingTime,
              ),
              const SizedBox(height: AppSizes.spaceL),
              _FilterSection(
                title: 'Course Type',
                options: _courseTypeOptions,
                selectedValue: _selectedCourseType,
                onSelected: _toggleCourseType,
              ),
              const SizedBox(height: AppSizes.spaceL),
              _FilterSection(
                title: 'Cuisine',
                options: _cuisineOptions,
                selectedValue: _selectedCuisine,
                onSelected: _toggleCuisine,
              ),
              const SizedBox(height: AppSizes.spaceXL),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: AppSizes.spaceM),
              Text(
                '${filteredRecipes.length} recipes found',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 15),
              ),
              const SizedBox(height: AppSizes.spaceM),
              filteredRecipes.isEmpty
                  ? const _EmptySearchState()
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredRecipes.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.spaceM,
                  crossAxisSpacing: AppSizes.spaceM,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];

                  return _RecipeSearchCard(
                    recipe: recipe,
                    onTap: () =>
                        _goToRecipeDetail(recipe['id'] as String),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const _FilterSection({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodySecondary.copyWith(fontSize: 15)),
        const SizedBox(height: AppSizes.spaceS),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: options.map((option) {
            final isSelected = selectedValue == option;

            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTextStyles.body.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RecipeSearchCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;

  const _RecipeSearchCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = recipe['title'] as String? ?? '';
    final imageUrl = recipe['imageUrl'] as String? ?? '';
    final cookTime = recipe['cookTimeMinutes']?.toString() ?? '0';
    final difficulty = recipe['difficulty'] as String? ?? '-';
    final rating = recipe['ratingAverage']?.toString() ?? '0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusM),
                topRight: Radius.circular(AppSizes.radiusM),
              ),
              child: Image.network(
                imageUrl,
                height: 132,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: AppSizes.iconS,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text('$cookTime m', style: AppTextStyles.caption),
                        const SizedBox(width: AppSizes.spaceS),
                        const Icon(
                          Icons.bar_chart_rounded,
                          size: AppSizes.iconS,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Expanded(
                          child: Text(
                            difficulty,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: AppSizes.iconS,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(
                          rating,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            'No recipes found',
            style: AppTextStyles.h2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            'Try changing your keywords or filters.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}
