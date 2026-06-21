import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/models/review_model.dart';

import 'package:siresep/providers/recipe_detail_provider.dart';
import 'package:siresep/providers/favorite_provider.dart';
import 'package:siresep/providers/shopping_list_provider.dart';
import 'package:siresep/providers/review_provider.dart';
import 'package:siresep/providers/recipe_provider.dart';

import 'package:siresep/pages/review/add_review_page.dart';
import 'package:siresep/pages/shopping_list/shopping_list_page.dart';

import 'package:siresep/pages/recipe_detail/widgets/ingredients_section.dart';
import 'package:siresep/pages/recipe_detail/widgets/instructions_section.dart';
import 'package:siresep/pages/recipe_detail/widgets/recipe_hero_section.dart';
import 'package:siresep/pages/recipe_detail/widgets/reviews_section.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    final String? recipeId =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (recipeId == null || recipeId.isEmpty) {
      return;
    }

    Future.microtask(() async {
      await context.read<RecipeDetailProvider>().loadRecipe(recipeId);

      await context.read<ReviewProvider>().loadRecipeReviews(recipeId);
    });

    _isInitialized = true;
  }

  void _goBackToHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, true);

      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  Future<void> _openWriteReviewModal() async {
    final provider = context.read<RecipeDetailProvider>();

    final reviewProvider = context.read<ReviewProvider>();

    final recipe = provider.recipe;

    if (recipe == null) {
      return;
    }

    final Map<String, dynamic>? result =
    await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddReviewPage(recipeTitle: recipe.title);
      },
    );

    if (result == null) {
      return;
    }

    final int? rating = result['rating'] as int?;

    final String? comment = result['comment'] as String?;

    if (rating == null || rating == 0 || comment == null || comment.isEmpty) {
      return;
    }

    try {
      await reviewProvider.addReview(
        recipeId: recipe.id,
        rating: rating,
        comment: comment,
      );

      await Future.wait([
        context.read<RecipeDetailProvider>().loadRecipe(recipe.id),
        context.read<ReviewProvider>().loadRecipeReviews(recipe.id),
        context.read<RecipeProvider>().loadRecipes(),
      ]);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeDetailProvider>();

    final favoriteProvider = context.watch<FavoriteProvider>();

    final shoppingListProvider =
    context.read<
        ShoppingListProvider>();

    final reviewProvider = context.watch<ReviewProvider>();

    final RecipeModel? recipe = provider.recipe;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (recipe == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            provider.errorMessage ?? 'Resep tidak ditemukan',
            style: AppTextStyles.bodySecondary,
          ),
        ),
      );
    }

    final List<ReviewModel> reviews = reviewProvider.reviews;

    final double averageRating =
        recipe.ratingAverage;

    final int totalReviews =
        recipe.reviewCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            RecipeHeroSection(
              imageUrl: recipe.imageUrl.trim().isEmpty
                  ? 'https://dummyimage.com/600x400/e5e7eb/6b7280&text=SiResep'
                  : recipe.imageUrl,
              title: recipe.title,
              description: recipe.description,
              cookTime: recipe.cookTimeMinutes.toString(),
              difficulty: recipe.difficulty,
              rating: averageRating.toStringAsFixed(1),
              totalReviews: totalReviews,
              isFavorite: favoriteProvider.isFavorite(recipe.id),
              onBackTap: _goBackToHome,
              onFavoriteTap: () async {
                await favoriteProvider.toggleFavorite(recipe.id);
                await favoriteProvider.loadFavorites();

                if (!mounted) {
                  return;
                }

                final isNowFavorite = favoriteProvider.isFavorite(recipe.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isNowFavorite
                          ? 'Recipe added to favorites'
                          : 'Recipe removed from favorites',
                    ),
                  ),
                );
              },
            ),

            Transform.translate(
              offset: const Offset(0, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingL,
                  AppSizes.paddingL,
                  AppSizes.paddingL,
                  AppSizes.paddingXL,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusXL),
                    topRight: Radius.circular(AppSizes.radiusXL),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IngredientsSection(
                      ingredients: recipe.ingredients,
                      selectedServings: provider.selectedServings,
                      onDecrease: provider.decreaseServings,
                      onIncrease: provider.increaseServings,
                      scaledQuantityBuilder: (quantity) {
                        return provider.formatQuantity(
                          provider.scaledQuantity(quantity),
                        );
                      },
                    ),

                    const SizedBox(height: AppSizes.spaceL),

                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () async {
                          await shoppingListProvider.addRecipeIngredients(
                            recipe,
                            provider.selectedServings,
                          );

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

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ingredients added to shopping list',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          'Add to Shopping List',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.spaceXL),

                    InstructionsSection(instructions: recipe.instructions),

                    const SizedBox(height: AppSizes.spaceXL),

                    ReviewsSection(
                      reviews: reviews,
                      totalReviews: totalReviews,
                      isLoading:
                      reviewProvider.isLoading,
                      onWriteReviewTap:
                      _openWriteReviewModal,
                      formatReviewDate:
                      provider.formatReviewDate,
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
