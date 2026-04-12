import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h2,
          ),
        ),
        if (actionText != null && onActionTap != null)
          GestureDetector(
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.spaceS),
              child: Text(
                actionText!,
                style: AppTextStyles.bodySecondary.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}