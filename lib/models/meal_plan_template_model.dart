import 'package:cloud_firestore/cloud_firestore.dart';

class MealPlanTemplateModel {
  final String id;
  final String name;
  final String description;
  final String status;
  final Map<String, Map<String, String?>> mealPlan;

  MealPlanTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.mealPlan,
  });

  factory MealPlanTemplateModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return MealPlanTemplateModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      status: data['status']?.toString() ?? 'draft',
      mealPlan: _parseMealPlan(data['mealPlan']),
    );
  }

  static Map<String, Map<String, String?>> _parseMealPlan(dynamic value) {
    final result = <String, Map<String, String?>>{};

    if (value is! Map) return result;

    for (final dayEntry in value.entries) {
      final day = dayEntry.key.toString();
      final meals = <String, String?>{};

      if (dayEntry.value is Map) {
        final rawMeals = dayEntry.value as Map;

        for (final mealEntry in rawMeals.entries) {
          meals[mealEntry.key.toString()] = mealEntry.value?.toString();
        }
      }

      result[day] = meals;
    }

    return result;
  }
}
