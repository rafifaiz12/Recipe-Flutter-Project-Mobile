import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal_plan_model.dart';

class MealPlanService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    return user.uid;
  }

  CollectionReference<
      Map<String, dynamic>>
  get _mealPlanCollection =>
      _firestore
          .collection('users')
          .doc(_userId)
          .collection(
        'meal_plans',
      );

  Future<List<MealPlanModel>>
  getMealPlans() async {
    final snapshot =
    await _mealPlanCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          MealPlanModel
              .fromFirestore(
            doc,
          ),
    )
        .toList();
  }

  Future<void> addMealPlan(
      MealPlanModel mealPlan,
      ) async {
    final existing =
    await _mealPlanCollection
        .where(
      'day',
      isEqualTo:
      mealPlan.day,
    )
        .where(
      'mealType',
      isEqualTo:
      mealPlan
          .mealType,
    )
        .get();

    final batch =
    _firestore.batch();

    for (final doc
    in existing.docs) {
      batch.delete(
        doc.reference,
      );
    }

    batch.set(
      _mealPlanCollection.doc(
        mealPlan.id,
      ),
      mealPlan.toFirestore(),
    );

    await batch.commit();
  }

  Future<void> deleteMealPlan({
    required String day,
    required String mealType,
  }) async {
    final snapshot =
    await _mealPlanCollection
        .where(
      'day',
      isEqualTo: day,
    )
        .where(
      'mealType',
      isEqualTo:
      mealType,
    )
        .get();

    final batch =
    _firestore.batch();

    for (final doc
    in snapshot.docs) {
      batch.delete(
        doc.reference,
      );
    }

    await batch.commit();
  }

  Future<void> clearDayMeals(
      String day,
      ) async {
    final snapshot =
    await _mealPlanCollection
        .where(
      'day',
      isEqualTo: day,
    )
        .get();

    final batch =
    _firestore.batch();

    for (final doc
    in snapshot.docs) {
      batch.delete(
        doc.reference,
      );
    }

    await batch.commit();
  }
}