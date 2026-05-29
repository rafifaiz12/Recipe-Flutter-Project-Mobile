import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

import 'package:siresep/models/review_model.dart';

class ReviewCard
    extends StatelessWidget {
  final ReviewModel review;

  final String Function(
      DateTime date,
      )
  formatReviewDate;

  const ReviewCard({
    super.key,
    required this.review,
    required this.formatReviewDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.only(
            bottom:
            AppSizes.spaceL,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.userName,
                      style:
                      AppTextStyles
                          .body
                          .copyWith(
                        fontWeight:
                        FontWeight
                            .w600,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Text(
                    formatReviewDate(
                      review.createdAt,
                    ),
                    style:
                    AppTextStyles
                        .bodySecondary,
                  ),
                ],
              ),

              const SizedBox(
                height:
                AppSizes.spaceS,
              ),

              Row(
                children:
                List.generate(
                  5,
                      (starIndex) {
                    return Icon(
                      starIndex <
                          review
                              .rating
                          ? Icons.star
                          : Icons
                          .star_border,
                      color:
                      starIndex <
                          review
                              .rating
                          ? AppColors
                          .primary
                          : AppColors
                          .textSecondary,
                      size:
                      AppSizes
                          .iconM,
                    );
                  },
                ),
              ),

              const SizedBox(
                height:
                AppSizes.spaceS,
              ),

              Text(
                review.comment,
                style:
                AppTextStyles
                    .body
                    .copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}