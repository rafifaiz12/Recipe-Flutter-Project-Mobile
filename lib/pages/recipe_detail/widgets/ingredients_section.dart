import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/ingredient_model.dart';

import 'package:siresep/pages/recipe_detail/widgets/servings_selector.dart';

class IngredientsSection
    extends StatelessWidget {
  final List<IngredientModel>
  ingredients;

  final int selectedServings;

  final VoidCallback onDecrease;

  final VoidCallback onIncrease;

  final String Function(
      double quantity,
      )
  scaledQuantityBuilder;

  const IngredientsSection({
    super.key,
    required this.ingredients,
    required this.selectedServings,
    required this.onDecrease,
    required this.onIncrease,
    required this.scaledQuantityBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ingredients',
                style:
                AppTextStyles.h1
                    .copyWith(
                  fontSize: 24,
                  fontWeight:
                  FontWeight
                      .w700,
                ),
              ),
            ),

            ServingsSelector(
              selectedServings:
              selectedServings,
              onDecrease:
              onDecrease,
              onIncrease:
              onIncrease,
            ),
          ],
        ),

        const SizedBox(
          height:
          AppSizes.spaceL,
        ),

        ...ingredients.asMap().entries.map(
              (entry) {
            final int index =
                entry.key;

            final ingredient =
                entry.value;

            return Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical:
                    AppSizes
                        .paddingM,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ingredient
                              .name,
                          style:
                          AppTextStyles
                              .body
                              .copyWith(
                            fontSize:
                            18,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceM,
                      ),

                      Text(
                        '${scaledQuantityBuilder(ingredient.quantity)} ${ingredient.unit}',
                        style:
                        AppTextStyles
                            .body
                            .copyWith(
                          fontSize:
                          18,
                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                      ),
                    ],
                  ),
                ),

                if (index !=
                    ingredients
                        .length -
                        1)
                  const Divider(
                    height: 1,
                    color:
                    AppColors
                        .border,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}