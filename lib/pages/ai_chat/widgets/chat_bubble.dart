import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSizes.radiusL),
            topRight: const Radius.circular(AppSizes.radiusL),
            bottomLeft: Radius.circular(
              isUser ? AppSizes.radiusL : AppSizes.radiusS,
            ),
            bottomRight: Radius.circular(
              isUser ? AppSizes.radiusS : AppSizes.radiusL,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message,
          style: AppTextStyles.body.copyWith(
            color: isUser ? Colors.white : AppColors.textPrimary,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}