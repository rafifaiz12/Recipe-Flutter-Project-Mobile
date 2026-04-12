import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(fontSize: 20),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSizes.spaceL),
              SizedBox(
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  child: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}