import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class RecipeHeroSection
    extends StatelessWidget {
  final String imageUrl;

  final String title;

  final String description;

  final String cookTime;

  final String difficulty;

  final String rating;

  final int totalReviews;

  final bool isFavorite;

  final VoidCallback onBackTap;

  final VoidCallback onFavoriteTap;

  const RecipeHeroSection({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.cookTime,
    required this.difficulty,
    required this.rating,
    required this.totalReviews,
    required this.isFavorite,
    required this.onBackTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Image.network(
                  'https://dummyimage.com/600x400/e5e7eb/6b7280&text=SiResep',
                  fit: BoxFit.cover,
                );
              },
            )
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient:
                LinearGradient(
                  begin:
                  Alignment
                      .topCenter,
                  end:
                  Alignment
                      .bottomCenter,
                  colors: [
                    Colors.black
                        .withValues(
                      alpha: 0.12,
                    ),
                    Colors.black
                        .withValues(
                      alpha: 0.60,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.all(
                AppSizes.paddingL,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons
                            .arrow_back_ios_new,
                        onTap:
                        onBackTap,
                      ),

                      const Spacer(),

                      _CircleIconButton(
                        icon:
                        isFavorite
                            ? Icons
                            .favorite
                            : Icons
                            .favorite_border,
                        onTap:
                        onFavoriteTap,
                        iconColor:
                        isFavorite
                            ? AppColors
                            .error
                            : AppColors
                            .textPrimary,
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    title,
                    style:
                    AppTextStyles
                        .h1
                        .copyWith(
                      color:
                      Colors.white,
                      fontSize: 38,
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
                    description,
                    style:
                    AppTextStyles
                        .body
                        .copyWith(
                      color: Colors
                          .white
                          .withValues(
                        alpha: 0.92,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height:
                    AppSizes.spaceM,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .schedule_outlined,
                        color:
                        Colors.white,
                        size:
                        AppSizes
                            .iconM,
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceXS,
                      ),

                      Text(
                        '$cookTime min',
                        style:
                        AppTextStyles
                            .body
                            .copyWith(
                          color:
                          Colors
                              .white,
                        ),
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceM,
                      ),

                      const Icon(
                        Icons
                            .bar_chart_rounded,
                        color:
                        Colors.white,
                        size:
                        AppSizes
                            .iconM,
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceXS,
                      ),

                      Text(
                        difficulty,
                        style:
                        AppTextStyles
                            .body
                            .copyWith(
                          color:
                          Colors
                              .white,
                        ),
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceM,
                      ),

                      const Icon(
                        Icons.star,
                        color:
                        Colors.white,
                        size:
                        AppSizes
                            .iconM,
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceXS,
                      ),

                      Text(
                        rating,
                        style:
                        AppTextStyles
                            .body
                            .copyWith(
                          color:
                          Colors
                              .white,
                        ),
                      ),

                      const SizedBox(
                        width:
                        AppSizes
                            .spaceXS,
                      ),

                      Text(
                        '($totalReviews)',
                        style:
                        AppTextStyles
                            .caption
                            .copyWith(
                          color:
                          Colors.white
                              .withValues(
                            alpha: 0.80,
                          ),
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
    );
  }
}

class _CircleIconButton
    extends StatelessWidget {
  final IconData icon;

  final VoidCallback onTap;

  final Color? iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
      Colors.white.withValues(
        alpha: 0.92,
      ),
      shape:
      const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          height: 52,
          width: 52,
          child: Icon(
            icon,
            color:
            iconColor ??
                AppColors
                    .textPrimary,
            size:
            AppSizes.iconM,
          ),
        ),
      ),
    );
  }
}