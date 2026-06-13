import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:siresep/models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  List<ReviewModel> _reviews = [];

  bool _isLoading = false;

  List<ReviewModel> get reviews =>
      _reviews;

  bool get isLoading =>
      _isLoading;

  /*
  |--------------------------------------------------------------------------
  | LOAD RECIPE REVIEWS
  |--------------------------------------------------------------------------
  */

  Future<void> loadRecipeReviews(
      String recipeId,
      ) async {
    _isLoading = true;

    notifyListeners();

    try {
      final snapshot =
      await _firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('reviews')
          .orderBy(
        'createdAt',
        descending: true,
      )
          .get();

      _reviews = snapshot.docs
          .map(
            (doc) => ReviewModel.fromMap(
          {
            'id': doc.id,
            ...doc.data(),
          },
        ),
      )
          .toList();
    } catch (e) {
      debugPrint(
        'Load Reviews Error: $e',
      );

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
    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    final reviewRef =
    _firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('reviews')
        .doc();

    final review = ReviewModel(
      id: reviewRef.id,
      recipeId: recipeId,
      userId: user.uid,
      userName:
      user.displayName ??
          'Anonymous',
      userPhotoUrl:
      user.photoURL ?? '',
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    try {
      await reviewRef.set(
        review.toMap(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'reviewCount':
        FieldValue.increment(1),
      });

      debugPrint(
        'Review berhasil disimpan',
      );
    } catch (e) {
      debugPrint(
        'Review gagal disimpan: $e',
      );

      rethrow;
    }

    await _updateRecipeRating(
      recipeId,
    );

    await loadRecipeReviews(
      recipeId,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE RECIPE RATING
  |--------------------------------------------------------------------------
  */

  Future<void> _updateRecipeRating(
      String recipeId,
      ) async {
    final reviewsSnapshot =
    await _firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('reviews')
        .get();

    if (reviewsSnapshot.docs.isEmpty) {
      await _firestore
          .collection('recipes')
          .doc(recipeId)
          .update({
        'ratingAverage': 0.0,
        'reviewCount': 0,
        'updatedAt':
        Timestamp.now(),
      });

      return;
    }

    double totalRating = 0;

    for (final doc
    in reviewsSnapshot.docs) {
      totalRating +=
          (doc.data()['rating']
          as num?)
              ?.toDouble() ??
              0;
    }

    final reviewCount =
        reviewsSnapshot.docs.length;

    final averageRating =
        totalRating /
            reviewCount;

    await _firestore
        .collection('recipes')
        .doc(recipeId)
        .update({
      'ratingAverage':
      averageRating,
      'reviewCount':
      reviewCount,
      'updatedAt':
      Timestamp.now(),
    });
  }

  /*
  |--------------------------------------------------------------------------
  | CURRENT USER REVIEWS
  |--------------------------------------------------------------------------
  */

  Future<List<ReviewModel>>
  getCurrentUserReviews() async {
    final user =
        _auth.currentUser;

    if (user == null) {
      return [];
    }

    final recipesSnapshot =
    await _firestore
        .collection('recipes')
        .get();

    final List<ReviewModel>
    userReviews = [];

    for (final recipe
    in recipesSnapshot.docs) {
      final reviewSnapshot =
      await recipe.reference
          .collection(
        'reviews',
      )
          .where(
        'userId',
        isEqualTo:
        user.uid,
      )
          .get();

      userReviews.addAll(
        reviewSnapshot.docs.map(
              (doc) =>
              ReviewModel.fromMap(
                {
                  'id': doc.id,
                  ...doc.data(),
                },
              ),
        ),
      );
    }

    return userReviews;
  }

  Future<int>
  getCurrentUserReviewCount() async {
    final reviews =
    await getCurrentUserReviews();

    return reviews.length;
  }

  /*
  |--------------------------------------------------------------------------
  | LEGACY SUPPORT
  |--------------------------------------------------------------------------
  */

  double averageRating(
      String recipeId,
      ) {
    if (_reviews.isEmpty) {
      return 0;
    }

    final total =
    _reviews.fold(
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
        _reviews.length;
  }

  int totalRecipeReviews(
      String recipeId,
      ) {
    return _reviews.length;
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