import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/recipe_model.dart';

class MealRecipeCard
    extends StatelessWidget {
  final RecipeModel recipe;

  final VoidCallback onTap;

  const MealRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final rating = recipe.ratingAverage;
    return Material(
      color: AppColors.card,
      borderRadius:
      BorderRadius.circular(
        AppSizes.radiusXL,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(
          AppSizes.radiusXL,
        ),
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(
              AppSizes.radiusXL,
            ),
            image: DecorationImage(
              image: NetworkImage(
                recipe.imageUrl,
              ),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
          ),
          child: Container(
            padding:
            const EdgeInsets.all(
              AppSizes.paddingL,
            ),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                AppSizes.radiusXL,
              ),
              gradient:
              LinearGradient(
                begin:
                Alignment
                    .topCenter,
                end:
                Alignment
                    .bottomCenter,
                colors: [
                  AppColors
                      .textPrimary
                      .withValues(
                    alpha: 0.08,
                  ),
                  AppColors
                      .textPrimary
                      .withValues(
                    alpha: 0.45,
                  ),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .end,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  recipe.title,
                  style:
                  AppTextStyles.h2
                      .copyWith(
                    color:
                    AppColors.card,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height:
                  AppSizes.spaceXS,
                ),

                Text(
                  '${recipe.cookTimeMinutes} min • '
                      '${recipe.difficulty} • '
                      '⭐ ${rating.toStringAsFixed(1)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.card,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}