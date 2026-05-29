import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/core/widgets/section_title.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/providers/recipe_provider.dart';
import 'package:siresep/providers/review_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
  TextEditingController();

  bool _showSuggestions = false;

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

  Future<void> _onSearchChanged(String value) async {
    await context
        .read<RecipeProvider>()
        .searchRecipes(value);

    setState(() {
      _showSuggestions = value.trim().isNotEmpty;
    });
  }

  void _goToRecipeDetail(String recipeId) {
    _searchController.clear();

    setState(() {
      _showSuggestions = false;
    });

    Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipeId,
    );
  }

  void _goToProfile() {
    Navigator.pushNamed(
      context,
      AppRoutes.profile,
    );
  }

  void _goToAiChat() {
    Navigator.pushNamed(
      context,
      AppRoutes.aiChat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider =
    context.watch<RecipeProvider>();

    final trendingRecipes =
        recipeProvider.trendingRecipes;

    final recommendedRecipes =
        recipeProvider.recipes;

    final searchResults =
        recipeProvider.searchResults;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: recipeProvider.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();

            setState(() {
              _showSuggestions = false;
            });
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSizes.paddingL,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            'Discover',
                            style:
                            AppTextStyles.h1
                                .copyWith(
                              fontSize: 34,
                              fontWeight:
                              FontWeight
                                  .w800,
                            ),
                          ),
                          const SizedBox(
                            height:
                            AppSizes.spaceS,
                          ),
                          Text(
                            'Hi, What do you want to cook today?',
                            style:
                            AppTextStyles
                                .bodySecondary
                                .copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToProfile,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .primary
                              .withValues(
                            alpha: 0.14,
                          ),
                          shape:
                          BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors
                              .primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceL,
                ),

                Column(
                  children: [
                    TextField(
                      controller:
                      _searchController,
                      onChanged:
                      _onSearchChanged,
                      decoration:
                      InputDecoration(
                        hintText:
                        'Search recipes...',
                        hintStyle:
                        AppTextStyles
                            .bodySecondary
                            .copyWith(
                          fontSize: 16,
                        ),
                        prefixIcon:
                        const Icon(
                          Icons.search,
                          color: AppColors
                              .textSecondary,
                        ),
                        fillColor:
                        Colors.white,
                        filled: true,
                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(
                            AppSizes.radiusXL,
                          ),
                          borderSide:
                          const BorderSide(
                            color: AppColors
                                .border,
                          ),
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(
                            AppSizes.radiusXL,
                          ),
                          borderSide:
                          const BorderSide(
                            color: AppColors
                                .primary,
                          ),
                        ),
                      ),
                    ),

                    if (_showSuggestions &&
                        searchResults
                            .isNotEmpty)
                      Container(
                        margin:
                        const EdgeInsets.only(
                          top:
                          AppSizes.spaceS,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            AppSizes.radiusM,
                          ),
                          border: Border.all(
                            color: AppColors
                                .border,
                          ),
                        ),
                        child:
                        ListView.separated(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount:
                          searchResults
                              .length >
                              5
                              ? 5
                              : searchResults
                              .length,
                          separatorBuilder:
                              (_, __) =>
                          const Divider(
                            height: 1,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            final recipe =
                            searchResults[
                            index];

                            return ListTile(
                              title: Text(
                                recipe.title,
                              ),
                              subtitle:
                              Text(
                                '${recipe.cookTimeMinutes} min • ${recipe.difficulty}',
                              ),
                              onTap: () =>
                                  _goToRecipeDetail(
                                    recipe.id,
                                  ),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height: AppSizes.spaceL,
                ),

                _AiRecipeAssistantCard(
                  onTap: _goToAiChat,
                ),

                const SizedBox(
                  height: AppSizes.spaceXL,
                ),

                const SectionTitle(
                  title: 'Trending Recipes',
                ),

                const SizedBox(
                  height: AppSizes.spaceM,
                ),

                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection:
                    Axis.horizontal,
                    itemCount:
                    trendingRecipes.length,
                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                      width:
                      AppSizes.spaceM,
                    ),
                    itemBuilder:
                        (context, index) {
                      final recipe =
                      trendingRecipes[
                      index];

                      return SizedBox(
                        width: 300,
                        child:
                        _HorizontalRecipeCard(
                          recipe: recipe,
                          onTap: () =>
                              _goToRecipeDetail(
                                recipe.id,
                              ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spaceXL,
                ),

                const SectionTitle(
                  title:
                  'Recommended For You',
                ),

                const SizedBox(
                  height: AppSizes.spaceM,
                ),

                Column(
                  children:
                  recommendedRecipes.map(
                        (recipe) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(
                          bottom:
                          AppSizes.spaceM,
                        ),
                        child:
                        _VerticalRecipeCard(
                          recipe: recipe,
                          onTap: () =>
                              _goToRecipeDetail(
                                recipe.id,
                              ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiRecipeAssistantCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AiRecipeAssistantCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppSizes.paddingL,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(
            AppSizes.radiusXL,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(
              width: AppSizes.spaceM,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask AI Recipe',
                    style: AppTextStyles.h2
                        .copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spaceXS,
                  ),
                  Text(
                    'Masukkan bahan yang tersedia dan dapatkan rekomendasi resep.',
                    style: AppTextStyles
                        .bodySecondary
                        .copyWith(
                      color: Colors.white
                          .withValues(
                        alpha: 0.88,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalRecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  final VoidCallback onTap;

  const _HorizontalRecipeCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final reviewProvider =
    context.watch<
        ReviewProvider>();

    final rating =
    reviewProvider
        .averageRating(
      recipe.id,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppSizes.radiusXL,
          ),
          image: DecorationImage(
            image: NetworkImage(recipe.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusXL,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(
                  alpha: 0.05,
                ),
                Colors.black.withValues(
                  alpha: 0.65,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.all(
            AppSizes.paddingM,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              Text(
                '${recipe.cookTimeMinutes} min • ${recipe.difficulty} • ⭐ ${rating.toStringAsFixed(1)}',
                style:
                AppTextStyles.caption.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: AppSizes.spaceS,
              ),
              Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalRecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  final VoidCallback onTap;

  const _VerticalRecipeCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final reviewProvider =
    context.watch<
        ReviewProvider>();

    final rating =
    reviewProvider
        .averageRating(
      recipe.id,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppSizes.radiusXL,
          ),
          image: DecorationImage(
            image: NetworkImage(recipe.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusXL,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(
                  alpha: 0.05,
                ),
                Colors.black.withValues(
                  alpha: 0.65,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.all(
            AppSizes.paddingM,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              Text(
                '${recipe.cookTimeMinutes} min • ${recipe.difficulty} • ⭐ ${rating.toStringAsFixed(1)}',
                style:
                AppTextStyles.caption.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: AppSizes.spaceS,
              ),
              Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}