import 'package:siresep/core/utils/dummy_data.dart';

import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/models/review_model.dart';

import 'package:siresep/services/recipe_service.dart';

class RecipeDetailService {
  final RecipeService _recipeService =
  RecipeService();

  Future<RecipeModel?> getRecipe(
      String recipeId,
      ) async {
    return _recipeService.getRecipeById(
      recipeId,
    );
  }

  Future<List<ReviewModel>> getReviews(
      String recipeId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    return DummyData.reviews
        .where(
          (review) =>
      review.recipeId == recipeId,
    )
        .toList();
  }

  Future<void> addReview({
    required String recipeId,
    required int rating,
    required String comment,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    DummyData.reviews.insert(
      0,
      ReviewModel(
        id:
        'review_${DateTime.now().millisecondsSinceEpoch}',
        recipeId: recipeId,
        userId: 'temporary_user',
        userName: 'Guest User',
        userPhotoUrl: '',
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
  }
  double calculateAverageRating(
      String recipeId,
      ) {
    final reviews =
    DummyData.reviews
        .where(
          (review) =>
      review.recipeId ==
          recipeId,
    )
        .toList();

    if (reviews.isEmpty) {
      return 0;
    }

    final total =
    reviews.fold(
      0.0,
          (
          previousValue,
          review,
          ) {
        return previousValue +
            review.rating;
      },
    );

    return total /
        reviews.length;
  }

  int totalReviews(
      String recipeId,
      ) {
    return DummyData.reviews
        .where(
          (review) =>
      review.recipeId ==
          recipeId,
    )
        .length;
  }
}