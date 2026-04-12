import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class MealSection extends StatelessWidget {
  final String title;
  final Widget child;

  const MealSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h2.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSizes.spaceM),
        child,
      ],
    );
  }
}