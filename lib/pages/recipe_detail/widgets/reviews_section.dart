import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/review_model.dart';

import 'package:siresep/pages/recipe_detail/widgets/review_card.dart';

class ReviewsSection
    extends StatelessWidget {
  final List<ReviewModel>
  reviews;

  final VoidCallback
  onWriteReviewTap;

  final String Function(
      DateTime date,
      )
  formatReviewDate;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.onWriteReviewTap,
    required this.formatReviewDate,
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
                'Rating & Reviews',
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

            TextButton(
              onPressed:
              onWriteReviewTap,
              child: Text(
                'Tulis Review',
                style:
                AppTextStyles
                    .body
                    .copyWith(
                  color:
                  AppColors
                      .primary,
                  fontWeight:
                  FontWeight
                      .w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height:
          AppSizes.spaceXS,
        ),

        Text(
          '${reviews.length} reviews',
          style:
          AppTextStyles
              .bodySecondary
              .copyWith(
            fontSize: 16,
          ),
        ),

        const SizedBox(
          height:
          AppSizes.spaceL,
        ),

        ...reviews.asMap().entries.map(
              (entry) {
            final int index =
                entry.key;

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
                    reviews.length -
                        1)
                  const Divider(
                    height: 1,
                    color:
                    AppColors
                        .border,
                  ),

                if (index !=
                    reviews.length -
                        1)
                  const SizedBox(
                    height:
                    AppSizes
                        .spaceL,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}