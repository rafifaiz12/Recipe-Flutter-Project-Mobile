import 'package:flutter/material.dart';

import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class InstructionsSection
    extends StatelessWidget {
  final List<String>
  instructions;

  const InstructionsSection({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions',
          style:
          AppTextStyles.h1
              .copyWith(
            fontSize: 24,
            fontWeight:
            FontWeight.w700,
          ),
        ),

        const SizedBox(
          height:
          AppSizes.spaceL,
        ),

        ...instructions.asMap().entries.map(
              (entry) {
            final int index =
                entry.key + 1;

            final String instruction =
                entry.value;

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom:
                AppSizes.spaceL,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration:
                    const BoxDecoration(
                      color:
                      AppColors
                          .primary,
                      shape:
                      BoxShape.circle,
                    ),
                    alignment:
                    Alignment.center,
                    child: Text(
                      '$index',
                      style:
                      AppTextStyles
                          .body
                          .copyWith(
                        color:
                        Colors
                            .white,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width:
                    AppSizes
                        .spaceM,
                  ),

                  Expanded(
                    child: Text(
                      instruction,
                      style:
                      AppTextStyles
                          .body
                          .copyWith(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}