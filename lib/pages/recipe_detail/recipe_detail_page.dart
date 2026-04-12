import 'package:flutter/material.dart';
import 'package:siresep/app/routes.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/pages/review/add_review_page.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Map<String, dynamic> _recipe;
  late List<Map<String, dynamic>> _reviews;

  int _selectedServings = 1;
  bool _isFavorite = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    final recipeId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'recipe_001';

    _recipe = DummyData.recipeById(recipeId) ?? DummyData.recipes.first;
    _reviews = List<Map<String, dynamic>>.from(
      DummyData.reviewsByRecipeId(_recipe['id']),
    );
    _selectedServings = (_recipe['servings'] as int?) ?? 1;
    _isFavorite = DummyData.favoriteRecipeIds.contains(_recipe['id']);
    _isInitialized = true;
  }

  void _goBackToHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Recipe added to favorites'
              : 'Recipe removed from favorites',
        ),
      ),
    );
  }

  void _addToShoppingList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ingredients added to shopping list')),
    );
  }

  Future<void> _openWriteReviewModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddReviewPage(recipeTitle: _recipe['title'] as String);
      },
    );

    if (result == null) {
      return;
    }

    final rating = result['rating'] as int?;
    final comment = result['comment'] as String?;

    if (rating == null || rating == 0 || comment == null || comment.isEmpty) {
      return;
    }

    setState(() {
      _reviews.insert(0, {
        'id': 'review_local_${DateTime.now().millisecondsSinceEpoch}',
        'recipeId': _recipe['id'],
        'userName': DummyData.currentUser['name'] ?? 'You',
        'rating': rating,
        'comment': comment,
        'createdAt': 'Today',
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review submitted')));
  }

  void _increaseServings() {
    setState(() {
      _selectedServings += 1;
    });
  }

  void _decreaseServings() {
    if (_selectedServings <= 1) {
      return;
    }

    setState(() {
      _selectedServings -= 1;
    });
  }

  double _scaledQuantity(double baseQuantity) {
    final baseServings = (_recipe['servings'] as int?) ?? 1;
    return (baseQuantity / baseServings) * _selectedServings;
  }

  String _formatQuantity(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  String _formatReviewDate(String value) {
    if (value == 'Today') {
      return value;
    }

    try {
      final createdAt = DateTime.parse(value);
      final difference = DateTime.now().difference(createdAt).inDays;

      if (difference <= 0) {
        return 'Today';
      }
      if (difference == 1) {
        return '1 day ago';
      }
      if (difference < 7) {
        return '$difference days ago';
      }
      if (difference < 14) {
        return '1 week ago';
      }

      final week = (difference / 7).floor();
      return '$week weeks ago';
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _recipe['title'] as String? ?? '';
    final description = _recipe['description'] as String? ?? '';
    final imageUrl = _recipe['imageUrl'] as String? ?? '';
    final cookTime = _recipe['cookTimeMinutes'].toString();
    final difficulty = _recipe['difficulty'] as String? ?? '';
    final rating = _recipe['ratingAverage'].toString();
    final reviewCount = _reviews.length;
    final ingredients = List<Map<String, dynamic>>.from(
      _recipe['ingredients'] as List,
    );
    final instructions = List<String>.from(_recipe['instructions'] as List);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _RecipeHeroSection(
              imageUrl: imageUrl,
              title: title,
              description: description,
              cookTime: cookTime,
              difficulty: difficulty,
              rating: rating,
              isFavorite: _isFavorite,
              onBackTap: _goBackToHome,
              onFavoriteTap: _toggleFavorite,
            ),
            Transform.translate(
              offset: const Offset(0, -AppSizes.spaceXL),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingL,
                  AppSizes.paddingL,
                  AppSizes.paddingL,
                  AppSizes.paddingXL,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusXL),
                    topRight: Radius.circular(AppSizes.radiusXL),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IngredientsSection(
                      ingredients: ingredients,
                      selectedServings: _selectedServings,
                      onDecrease: _decreaseServings,
                      onIncrease: _increaseServings,
                      scaledQuantityBuilder: (quantity) {
                        return _formatQuantity(_scaledQuantity(quantity));
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceL),
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _addToShoppingList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          'Add to Shopping List',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    _InstructionsSection(instructions: instructions),
                    const SizedBox(height: AppSizes.spaceXL),
                    _ReviewsSection(
                      reviews: _reviews,
                      reviewCount: reviewCount,
                      onWriteReviewTap: _openWriteReviewModal,
                      formatReviewDate: _formatReviewDate,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeHeroSection extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String cookTime;
  final String difficulty;
  final String rating;
  final bool isFavorite;
  final VoidCallback onBackTap;
  final VoidCallback onFavoriteTap;

  const _RecipeHeroSection({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.cookTime,
    required this.difficulty,
    required this.rating,
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
          Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.60),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: onBackTap,
                      ),
                      const Spacer(),
                      _CircleIconButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onTap: onFavoriteTap,
                        iconColor: isFavorite
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    description,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        color: Colors.white,
                        size: AppSizes.iconM,
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(
                        '$cookTime min',
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      const Icon(
                        Icons.bar_chart_rounded,
                        color: Colors.white,
                        size: AppSizes.iconM,
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(
                        difficulty,
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: AppSizes.iconM,
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(
                        rating,
                        style: AppTextStyles.body.copyWith(color: Colors.white),
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

class _CircleIconButton extends StatelessWidget {
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
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 52,
          width: 52,
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: AppSizes.iconM,
          ),
        ),
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  final List<Map<String, dynamic>> ingredients;
  final int selectedServings;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final String Function(double quantity) scaledQuantityBuilder;

  const _IngredientsSection({
    required this.ingredients,
    required this.selectedServings,
    required this.onDecrease,
    required this.onIncrease,
    required this.scaledQuantityBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ingredients',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onDecrease,
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.textPrimary,
                      size: AppSizes.iconM,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Text(
                    '$selectedServings servings',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  GestureDetector(
                    onTap: onIncrease,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.textPrimary,
                      size: AppSizes.iconM,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceL),
        ...ingredients.asMap().entries.map((entry) {
          final index = entry.key;
          final ingredient = entry.value;
          final quantity = (ingredient['quantity'] as num).toDouble();
          final unit = ingredient['unit'] as String? ?? '';
          final name = ingredient['name'] as String? ?? '';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.paddingM,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.body.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Text(
                      '${scaledQuantityBuilder(quantity)} $unit',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (index != ingredients.length - 1)
                const Divider(height: 1, color: AppColors.border),
            ],
          );
        }),
      ],
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  final List<String> instructions;

  const _InstructionsSection({required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions',
          style: AppTextStyles.h1.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.spaceL),
        ...instructions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final instruction = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Text(
                    instruction,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final int reviewCount;
  final VoidCallback onWriteReviewTap;
  final String Function(String value) formatReviewDate;

  const _ReviewsSection({
    required this.reviews,
    required this.reviewCount,
    required this.onWriteReviewTap,
    required this.formatReviewDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Rating & Reviews',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: onWriteReviewTap,
              child: Text(
                'Tulis Review',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Text(
          '$reviewCount reviews',
          style: AppTextStyles.bodySecondary.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSizes.spaceL),
        const SizedBox(height: AppSizes.spaceS),
        ...reviews.asMap().entries.map((entry) {
          final index = entry.key;
          final review = entry.value;
          final userName = review['userName'] as String? ?? '';
          final rating = review['rating'] as int? ?? 0;
          final comment = review['comment'] as String? ?? '';
          final createdAt = review['createdAt'] as String? ?? '';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          formatReviewDate(createdAt),
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < rating ? Icons.star : Icons.star_border,
                          color: starIndex < rating
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: AppSizes.iconM,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      comment,
                      style: AppTextStyles.body.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
              if (index != reviews.length - 1)
                const Divider(height: 1, color: AppColors.border),
              if (index != reviews.length - 1)
                const SizedBox(height: AppSizes.spaceL),
            ],
          );
        }),
      ],
    );
  }
}
