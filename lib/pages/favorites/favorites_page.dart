import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep/app/routes.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/core/widgets/empty_state_widget.dart';

import 'package:siresep/models/recipe_model.dart';

import 'package:siresep/providers/favorite_provider.dart';

class FavoritesPage
    extends StatefulWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  State<FavoritesPage>
  createState() =>
      _FavoritesPageState();
}

class _FavoritesPageState
    extends State<FavoritesPage> {
  final TextEditingController
  _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void>
  _goToRecipeDetail(
      String recipeId,
      ) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipeId,
    );

    if (!mounted) {
      return;
    }

    await context
        .read<
        FavoriteProvider>()
        .loadFavorites();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final provider =
    context.watch<
        FavoriteProvider>();

    final searchQuery =
    _searchController.text
        .trim()
        .toLowerCase();

    final filteredRecipes =
    provider.favoriteRecipes
        .where(
          (recipe) =>
          recipe.title
              .toLowerCase()
              .contains(
            searchQuery,
          ),
    )
        .toList();

    final hasFavorites =
        provider
            .favoriteRecipes
            .isNotEmpty;

    final hasSearchResult =
        filteredRecipes
            .isNotEmpty;

    return Scaffold(
      backgroundColor:
      AppColors.background,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
          child:
          CircularProgressIndicator(),
        )
            : Padding(
          padding:
          const EdgeInsets.all(
            AppSizes.paddingL,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                'Saved Recipes',
                style:
                AppTextStyles
                    .h1
                    .copyWith(
                  fontSize: 34,
                  fontWeight:
                  FontWeight
                      .w800,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceS,
              ),

              Text(
                'Your favorite dishes',
                style:
                AppTextStyles
                    .bodySecondary
                    .copyWith(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceL,
              ),

              TextField(
                controller:
                _searchController,
                onChanged:
                    (_) {
                  setState(
                        () {},
                  );
                },
                decoration:
                InputDecoration(
                  hintText:
                  'Search saved recipes...',
                  hintStyle:
                  AppTextStyles
                      .bodySecondary
                      .copyWith(
                    fontSize:
                    16,
                  ),
                  prefixIcon:
                  const Icon(
                    Icons.search,
                    color:
                    AppColors
                        .textSecondary,
                  ),
                  fillColor:
                  Colors
                      .white,
                  filled: true,
                  enabledBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      AppSizes
                          .radiusXL,
                    ),
                    borderSide:
                    const BorderSide(
                      color:
                      AppColors
                          .border,
                    ),
                  ),
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      AppSizes
                          .radiusXL,
                    ),
                    borderSide:
                    const BorderSide(
                      color:
                      AppColors
                          .primary,
                    ),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal:
                    AppSizes
                        .paddingM,
                    vertical:
                    18,
                  ),
                ),
              ),

              const SizedBox(
                height:
                AppSizes
                    .spaceL,
              ),

              Expanded(
                child:
                !hasFavorites
                    ? const EmptyStateWidget(
                  icon: Icons
                      .favorite_border,
                  title:
                  'Belum ada resep favorit',
                  subtitle:
                  'Tambahkan resep ke favorit agar lebih mudah ditemukan nanti.',
                )
                    : !hasSearchResult
                    ? const EmptyStateWidget(
                  icon:
                  Icons
                      .search_off,
                  title:
                  'Resep tidak ditemukan',
                  subtitle:
                  'Coba gunakan kata kunci lain.',
                )
                    : GridView.builder(
                  itemCount:
                  filteredRecipes
                      .length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    2,
                    crossAxisSpacing:
                    AppSizes
                        .spaceM,
                    mainAxisSpacing:
                    AppSizes
                        .spaceM,
                    childAspectRatio:
                    0.62,
                  ),
                  itemBuilder:
                      (
                      context,
                      index,
                      ) {
                    final recipe =
                    filteredRecipes[
                    index];

                    return _FavoriteRecipeCard(
                      recipe:
                      recipe,
                      onTap:
                          () =>
                          _goToRecipeDetail(
                            recipe
                                .id,
                          ),
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

class _FavoriteRecipeCard
    extends StatelessWidget {
  final RecipeModel recipe;

  final VoidCallback onTap;

  const _FavoriteRecipeCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {

    final rating =
        recipe.ratingAverage;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width:
                  double.infinity,
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      AppSizes
                          .radiusXL,
                    ),
                    image:
                    DecorationImage(
                      image:
                      NetworkImage(
                        recipe
                            .imageUrl,
                      ),
                      fit:
                      BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                        AppColors
                            .shadow,
                        blurRadius:
                        12,
                        offset:
                        Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration:
                    const BoxDecoration(
                      color:
                      Colors.white,
                      shape:
                      BoxShape
                          .circle,
                    ),
                    child:
                    const Icon(
                      Icons.favorite,
                      color:
                      AppColors
                          .primary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height:
            AppSizes.spaceM,
          ),

          Text(
            recipe.title,
            maxLines: 2,
            overflow:
            TextOverflow
                .ellipsis,
            style:
            AppTextStyles.h2
                .copyWith(
              fontSize: 18,
              fontWeight:
              FontWeight
                  .w700,
              height: 1.3,
            ),
          ),

          const SizedBox(
            height:
            AppSizes.spaceS,
          ),

          Row(
            children: [
              Text(
                '${recipe.cookTimeMinutes} min',
                style:
                AppTextStyles
                    .bodySecondary
                    .copyWith(
                  fontSize: 14,
                ),
              ),

              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  '•',
                ),
              ),

              const Icon(
                Icons.star,
                size: 18,
                color:
                Color(
                  0xFFEAB308,
                ),
              ),

              const SizedBox(
                width: 4,
              ),

              Text(
                rating.toStringAsFixed(1),
                style:
                AppTextStyles
                    .bodySecondary
                    .copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}