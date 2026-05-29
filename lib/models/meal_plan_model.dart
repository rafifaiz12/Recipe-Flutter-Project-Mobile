import 'package:siresep/core/utils/model_parsers.dart';

class MealPlanModel {
  final String id;

  final String userId;

  final String day;

  final String mealType;

  final String recipeId;

  final DateTime createdAt;

  MealPlanModel({
    required this.id,
    required this.userId,
    required this.day,
    required this.mealType,
    required this.recipeId,
    required this.createdAt,
  });

  factory MealPlanModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return MealPlanModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      day: map['day'] ?? '',
      mealType: map['mealType'] ?? '',
      recipeId: map['recipeId'] ?? '',
      createdAt:
      ModelParsers.parseDateTime(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'day': day,
      'mealType': mealType,
      'recipeId': recipeId,
      'createdAt': createdAt,
    };
  }

  MealPlanModel copyWith({
    String? id,
    String? userId,
    String? day,
    String? mealType,
    String? recipeId,
    DateTime? createdAt,
  }) {
    return MealPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      day: day ?? this.day,
      mealType:
      mealType ?? this.mealType,
      recipeId:
      recipeId ?? this.recipeId,
      createdAt:
      createdAt ?? this.createdAt,
    );
  }
}