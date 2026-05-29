import 'package:flutter/material.dart';

import 'package:siresep/core/utils/dummy_data.dart';

import 'package:siresep/models/review_model.dart';

import 'package:siresep/services/recipe_detail_service.dart';

class ReviewProvider
    extends ChangeNotifier {
  final RecipeDetailService
  _service =
  RecipeDetailService();

  List<ReviewModel>
  _reviews = [];

  bool _isLoading = false;

  List<ReviewModel>
  get reviews => _reviews;

  bool get isLoading =>
      _isLoading;

  /*
  |--------------------------------------------------------------------------
  | LOAD RECIPE REVIEWS
  |--------------------------------------------------------------------------
  */

  Future<void>
  loadRecipeReviews(
      String recipeId,
      ) async {
    _isLoading = true;

    notifyListeners();

    try {
      _reviews =
      await _service
          .getReviews(
        recipeId,
      );
    } catch (_) {
      _reviews = [];
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | ADD REVIEW
  |--------------------------------------------------------------------------
  */

  Future<void> addReview({
    required String recipeId,
    required int rating,
    required String comment,
  }) async {
    await _service.addReview(
      recipeId: recipeId,
      rating: rating,
      comment: comment,
    );

    await loadRecipeReviews(
      recipeId,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | USER REVIEWS
  |--------------------------------------------------------------------------
  */

  List<ReviewModel>
  getCurrentUserReviews() {
    return DummyData.reviews
        .where(
          (review) =>
      review.userId ==
          'temporary_user',
    )
        .toList();
  }

  /*
  |--------------------------------------------------------------------------
  | USER REVIEW COUNT
  |--------------------------------------------------------------------------
  */

  int get currentUserReviewCount {
    return getCurrentUserReviews()
        .length;
  }

  /*
  |--------------------------------------------------------------------------
  | AVERAGE RATING
  |--------------------------------------------------------------------------
  */

  double averageRating(
      String recipeId,
      ) {
    final recipeReviews =
    DummyData.reviews
        .where(
          (review) =>
      review.recipeId ==
          recipeId,
    )
        .toList();

    if (recipeReviews
        .isEmpty) {
      return 0;
    }

    final total =
    recipeReviews.fold(
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
        recipeReviews.length;
  }

  /*
  |--------------------------------------------------------------------------
  | TOTAL RECIPE REVIEWS
  |--------------------------------------------------------------------------
  */

  int totalRecipeReviews(
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

  /*
  |--------------------------------------------------------------------------
  | CLEAR
  |--------------------------------------------------------------------------
  */

  void clearReviews() {
    _reviews = [];

    notifyListeners();
  }
}