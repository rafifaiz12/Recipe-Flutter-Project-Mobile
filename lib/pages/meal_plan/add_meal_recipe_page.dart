import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';

class AddMealRecipePage extends StatefulWidget {
  final String mealType;

  const AddMealRecipePage({super.key, required this.mealType});

  @override
  State<AddMealRecipePage> createState() => _AddMealRecipePageState();
}

class _AddMealRecipePageState extends State<AddMealRecipePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<Map<String, dynamic>> get _filteredRecipes {
    return DummyData.recipes.where((recipe) {
      final title = (recipe['title'] as String? ?? '').toLowerCase();
      final description = (recipe['description'] as String? ?? '')
          .toLowerCase();
      final query = _query.toLowerCase();

      return query.isEmpty ||
          title.contains(query) ||
          description.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectRecipe(String recipeId) {
    Navigator.pop(context, recipeId);
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXL),
          topRight: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 52,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Add ${widget.mealType}',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Choose any recipe from your recipe list.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSizes.spaceL),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value.trim();
                  });
                },
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
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
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Expanded(
                child: recipes.isEmpty
                    ? Center(
                        child: Text(
                          'No recipes found',
                          style: AppTextStyles.bodySecondary,
                        ),
                      )
                    : ListView.separated(
                        itemCount: recipes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.spaceM),
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];

                          return _MealRecipeOptionCard(
                            title: recipe['title'] as String,
                            imageUrl: recipe['imageUrl'] as String,
                            subtitle:
                                '${recipe['cookTimeMinutes']} min • ${recipe['difficulty']} • ⭐ ${recipe['ratingAverage']}',
                            onTap: () => _selectRecipe(recipe['id'] as String),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealRecipeOptionCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String subtitle;
  final VoidCallback onTap;

  const _MealRecipeOptionCard({
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                child: Image.network(
                  imageUrl,
                  height: 72,
                  width: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 72,
                      width: 72,
                      color: AppColors.inputBg,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
