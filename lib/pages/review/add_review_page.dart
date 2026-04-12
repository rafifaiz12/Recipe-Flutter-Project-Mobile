import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/constants/app_strings.dart';

class AddReviewPage extends StatefulWidget {
  final String recipeTitle;

  const AddReviewPage({super.key, required this.recipeTitle});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _selectRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  void _submitReview() {
    Navigator.pop(context, {
      'rating': _selectedRating,
      'comment': _commentController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL,
        AppSizes.paddingL + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXL),
          topRight: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Write Review',
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Share your experience for ${widget.recipeTitle}',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Your Rating',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSizes.spaceM),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  final ratingValue = index + 1;
                  final isSelected = ratingValue <= _selectedRating;

                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.spaceS),
                    child: GestureDetector(
                      onTap: () => _selectRating(ratingValue),
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: AppSizes.iconL,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Comment',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _commentController,
                maxLines: 5,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  hintStyle: AppTextStyles.bodySecondary,
                  filled: true,
                  fillColor: AppColors.inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(AppSizes.paddingM),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: _selectedRating == 0 ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                  ),
                  child: Text(AppStrings.save, style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
