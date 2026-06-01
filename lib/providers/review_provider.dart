import 'package:flutter/material.dart';

import 'package:siresep/core/utils/dummy_data.dart';
import 'package:siresep/models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _reviews = [];
  bool _isLoading = false;

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> loadRecipeReviews(String recipeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = DummyData.reviews
          .where((review) => review.recipeId == recipeId)
          .toList();
    } catch (_) {
      _reviews = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String recipeId,
    required int rating,
    required String comment,
  }) async {
    // Sementara dibuat no-op agar tidak mengganggu demo Firestore recipe.
    // Integrasi review ke Firestore bisa dikerjakan setelah login + list/detail resep selesai.

    await loadRecipeReviews(recipeId);
  }

  List<ReviewModel> getCurrentUserReviews() {
    return DummyData.reviews
        .where((review) => review.userId == 'temporary_user')
        .toList();
  }

  int get currentUserReviewCount {
    return getCurrentUserReviews().length;
  }

  double averageRating(String recipeId) {
    final recipeReviews = DummyData.reviews
        .where((review) => review.recipeId == recipeId)
        .toList();

    if (recipeReviews.isEmpty) {
      return 0;
    }

    final total = recipeReviews.fold(0.0, (previousValue, review) {
      return previousValue + review.rating;
    });

    return total / recipeReviews.length;
  }

  int totalRecipeReviews(String recipeId) {
    return DummyData.reviews
        .where((review) => review.recipeId == recipeId)
        .length;
  }

  void clearReviews() {
    _reviews = [];
    notifyListeners();
  }
}
