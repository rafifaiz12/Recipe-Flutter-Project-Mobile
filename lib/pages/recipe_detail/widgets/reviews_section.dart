import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/review_model.dart';

import 'package:siresep/pages/recipe_detail/widgets/review_card.dart';

class ReviewsSection extends StatelessWidget {
  final List<ReviewModel> reviews;

  final int totalReviews;

  final bool isLoading;

  final VoidCallback onWriteReviewTap;

  final String Function(
      DateTime date,
      ) formatReviewDate;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.totalReviews,
    required this.isLoading,
    required this.onWriteReviewTap,
    required this.formatReviewDate,
  });

  @override
  Widget build(BuildContext context) {
    final reviewLabel =
    totalReviews == 1
        ? 'review'
        : 'reviews';

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Rating & Reviews',
                style:
                AppTextStyles.h1.copyWith(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),

            TextButton(
              onPressed:
              onWriteReviewTap,
              child: Text(
                'Write Review',
                style:
                AppTextStyles.body.copyWith(
                  color:
                  AppColors.primary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: AppSizes.spaceXS,
        ),

        Text(
          '$totalReviews $reviewLabel',
          style:
          AppTextStyles.bodySecondary
              .copyWith(
            fontSize: 16,
          ),
        ),

        const SizedBox(
          height: AppSizes.spaceL,
        ),

        if (isLoading)
          const Center(
            child:
            CircularProgressIndicator(),
          )
        else if (reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              AppSizes.paddingL,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius:
              BorderRadius.circular(
                AppSizes.radiusM,
              ),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Text(
              'Belum ada review untuk resep ini.',
              style:
              AppTextStyles.bodySecondary,
            ),
          )
        else
          ...reviews.asMap().entries.map(
                (entry) {
              final index = entry.key;

              final review =
                  entry.value;

              return Column(
                children: [
                  ReviewCard(
                    review: review,
                    formatReviewDate:
                    formatReviewDate,
                  ),

                  if (index !=
                      reviews.length - 1)
                    const Divider(
                      height: 1,
                      color:
                      AppColors.border,
                    ),

                  if (index !=
                      reviews.length - 1)
                    const SizedBox(
                      height:
                      AppSizes.spaceL,
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}