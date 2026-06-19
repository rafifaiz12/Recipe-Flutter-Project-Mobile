import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/providers/recipe_provider.dart';
import 'package:siresep/providers/review_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  String? _selectedCookingTime;

  String? _selectedDishType;

  String? _selectedMealType;

  String? _selectedCuisine;

  String? _selectedDietType;

  final List<String> _cookingTimeOptions = const [
    '<15 minutes',
    '15 minutes - 1 hour',
    '>1 hour',
  ];

  final List<String> _dishTypeOptions = const [
    'Makanan Utama',
    'Dessert',
    'Minuman',
    'Snack',
    'Appetizer',
  ];

  final List<String> _mealTypeOptions = const [
    'Breakfast',
    'Lunch',
    'Dinner',
  ];

  final List<String> _cuisineOptions = const [
    'Nusantara',
    'Asian',
    'Western',
    'Middle Eastern',
  ];

  final List<String> _dietTypeOptions = const [
    'Regular',
    'Vegetarian',
    'Vegan',
    'High Protein',
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  List<RecipeModel> _filterRecipes(
      List<RecipeModel> recipes,
      ) {
    final filteredRecipes = recipes.where((recipe) {
      final query = _searchQuery.toLowerCase();

      final matchesQuery =
          query.isEmpty ||
              recipe.title.toLowerCase().contains(query) ||
              recipe.description.toLowerCase().contains(query);

      final cookTime = recipe.cookTimeMinutes;

      final matchesCookingTime =
          _selectedCookingTime == null ||
              (_selectedCookingTime == '<15 minutes' &&
                  cookTime < 15) ||
              (_selectedCookingTime ==
                  '15 minutes - 1 hour' &&
                  cookTime >= 15 &&
                  cookTime <= 60) ||
              (_selectedCookingTime == '>1 hour' &&
                  cookTime > 60);

      final matchesDishType =
          _selectedDishType == null ||
              recipe.dishType ==
                  _selectedDishType;

      final matchesMealType =
          _selectedMealType == null ||
              recipe.mealType ==
                  _selectedMealType;

      final matchesCuisine =
          _selectedCuisine == null ||
              recipe.cuisine ==
                  _selectedCuisine;

      final matchesDietType =
          _selectedDietType == null ||
              recipe.dietType ==
                  _selectedDietType;

      return matchesQuery &&
          matchesCookingTime &&
          matchesDishType &&
          matchesMealType &&
          matchesCuisine &&
          matchesDietType;
    }).toList();

    filteredRecipes.sort((a, b) {
      final aTrending = a.isTrending ? 1 : 0;

      final bTrending = b.isTrending ? 1 : 0;

      return bTrending.compareTo(aTrending);
    });

    return filteredRecipes;
  }

  void _goToRecipeDetail(String recipeId) {
    Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipeId,
    );
  }

  void _toggleCookingTime(String value) {
    setState(() {
      _selectedCookingTime =
      _selectedCookingTime == value
          ? null
          : value;
    });
  }

  void _toggleDishType(String value) {
    setState(() {
      _selectedDishType =
      _selectedDishType == value
          ? null
          : value;
    });
  }

  void _toggleMealType(String value) {
    setState(() {
      _selectedMealType =
      _selectedMealType == value
          ? null
          : value;
    });
  }

  void _toggleDietType(String value) {
    setState(() {
      _selectedDietType =
      _selectedDietType == value
          ? null
          : value;
    });
  }

  void _toggleCuisine(String value) {
    setState(() {
      _selectedCuisine =
      _selectedCuisine == value
          ? null
          : value;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(
                AppSizes.paddingL,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Filters',
                      style: AppTextStyles.h2,
                    ),

                    const SizedBox(height: 20),

                    _FilterSection(
                      title: 'Cooking Time',
                      options: _cookingTimeOptions,
                      selectedValue:
                      _selectedCookingTime,
                      onSelected: (value) {
                        setState(() {
                          _selectedCookingTime =
                          _selectedCookingTime ==
                              value
                              ? null
                              : value;
                        });

                        setModalState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    _FilterSection(
                      title: 'Dish Type',
                      options: _dishTypeOptions,
                      selectedValue:
                      _selectedDishType,
                      onSelected: (value) {
                        setState(() {
                          _selectedDishType =
                          _selectedDishType ==
                              value
                              ? null
                              : value;
                        });

                        setModalState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    _FilterSection(
                      title: 'Meal Type',
                      options: _mealTypeOptions,
                      selectedValue:
                      _selectedMealType,
                      onSelected: (value) {
                        setState(() {
                          _selectedMealType =
                          _selectedMealType ==
                              value
                              ? null
                              : value;
                        });

                        setModalState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    _FilterSection(
                      title: 'Cuisine',
                      options: _cuisineOptions,
                      selectedValue:
                      _selectedCuisine,
                      onSelected: (value) {
                        setState(() {
                          _selectedCuisine =
                          _selectedCuisine ==
                              value
                              ? null
                              : value;
                        });

                        setModalState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    _FilterSection(
                      title: 'Diet Type',
                      options: _dietTypeOptions,
                      selectedValue:
                      _selectedDietType,
                      onSelected: (value) {
                        setState(() {
                          _selectedDietType =
                          _selectedDietType ==
                              value
                              ? null
                              : value;
                        });

                        setModalState(() {});
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.primary,
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int get activeFilterCount {
    int count = 0;

    if (_selectedCookingTime != null) count++;
    if (_selectedDishType != null) count++;
    if (_selectedMealType != null) count++;
    if (_selectedCuisine != null) count++;
    if (_selectedDietType != null) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider =
    context.watch<RecipeProvider>();

    final filteredRecipes = _filterRecipes(
      recipeProvider.recipes,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: recipeProvider.isLoading
            ? const Center(
          child:
          CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSizes.paddingL,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Recipes',
                style:
                AppTextStyles.h1.copyWith(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: AppSizes.spaceL,
              ),

              TextField(
                controller:
                _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery =
                        value.trim();
                  });
                },
                style: AppTextStyles.body,
                decoration:
                InputDecoration(
                  hintText:
                  'Search recipes or ingredients...',
                  hintStyle:
                  AppTextStyles
                      .bodySecondary,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors
                        .textSecondary,
                  ),
                  filled: true,
                  fillColor:
                  AppColors.inputBg,
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      AppSizes.radiusM,
                    ),
                    borderSide:
                    BorderSide.none,
                  ),
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      AppSizes.radiusM,
                    ),
                    borderSide:
                    const BorderSide(
                      color:
                      AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSizes.spaceL,
              ),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFilterBottomSheet,
                      icon: const Icon(
                        Icons.tune_rounded,
                      ),
                      label: Text(
                        activeFilterCount == 0
                            ? 'Filters'
                            : 'Filters ($activeFilterCount)',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSizes.spaceL,
              ),

              Container(
                height: 1,
                color: AppColors.border,
              ),

              const SizedBox(
                height: AppSizes.spaceM,
              ),

              Text(
                '${filteredRecipes.length} recipes found',
                style: AppTextStyles
                    .bodySecondary
                    .copyWith(
                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: AppSizes.spaceM,
              ),

              filteredRecipes.isEmpty
                  ? const _EmptySearchState()
                  : GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount:
                filteredRecipes
                    .length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing:
                  AppSizes
                      .spaceM,
                  crossAxisSpacing:
                  AppSizes
                      .spaceM,
                  childAspectRatio:
                  0.60,
                ),
                itemBuilder:
                    (context, index) {
                  final recipe =
                  filteredRecipes[
                  index];

                  return _RecipeSearchCard(
                    recipe: recipe,
                    onTap: () =>
                        _goToRecipeDetail(
                          recipe.id,
                        ),
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
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySecondary
              .copyWith(fontSize: 15),
        ),

        const SizedBox(
          height: AppSizes.spaceS,
        ),

        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: options.map((option) {
            final isSelected =
                selectedValue == option;

            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                padding:
                const EdgeInsets.symmetric(
                  horizontal:
                  AppSizes.paddingM,
                  vertical:
                  AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.card,
                  borderRadius:
                  BorderRadius.circular(
                    AppSizes.radiusXL,
                  ),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  option,
                  style:
                  AppTextStyles.body
                      .copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppColors
                        .textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
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
  final RecipeModel recipe;

  final VoidCallback onTap;

  const _RecipeSearchCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rating = recipe.ratingAverage;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(
            AppSizes.radiusM,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.only(
                topLeft: Radius.circular(
                  AppSizes.radiusM,
                ),
                topRight: Radius.circular(
                  AppSizes.radiusM,
                ),
              ),
              child: Image.network(
                recipe.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSizes.paddingM,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: AppTextStyles.h2
                          .copyWith(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .schedule_outlined,
                          size:
                          AppSizes.iconS,
                          color: AppColors
                              .textSecondary,
                        ),

                        const SizedBox(
                          width:
                          AppSizes.spaceXS,
                        ),

                        Text(
                          '${recipe.cookTimeMinutes} m',
                          style:
                          AppTextStyles
                              .caption,
                        ),

                        const SizedBox(
                          width:
                          AppSizes.spaceS,
                        ),

                        const Icon(
                          Icons
                              .bar_chart_rounded,
                          size:
                          AppSizes.iconS,
                          color: AppColors
                              .textSecondary,
                        ),

                        const SizedBox(
                          width:
                          AppSizes.spaceXS,
                        ),

                        Expanded(
                          child: Text(
                            recipe.difficulty,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            AppTextStyles
                                .caption,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: AppSizes.spaceXS,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size:
                          AppSizes.iconS,
                          color:
                          AppColors.primary,
                        ),

                        const SizedBox(
                          width:
                          AppSizes.spaceXS,
                        ),

                        Text(
                          rating.toStringAsFixed(1),
                          style:
                          AppTextStyles
                              .caption
                              .copyWith(
                            color: AppColors
                                .textPrimary,
                            fontWeight:
                            FontWeight
                                .w600,
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
      padding: const EdgeInsets.all(
        AppSizes.paddingXL,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusL,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),

          const SizedBox(
            height: AppSizes.spaceM,
          ),

          Text(
            'No recipes found',
            style: AppTextStyles.h2.copyWith(
              fontSize: 20,
            ),
          ),

          const SizedBox(
            height: AppSizes.spaceS,
          ),

          Text(
            'Try changing your keywords or filters.',
            textAlign: TextAlign.center,
            style:
            AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}