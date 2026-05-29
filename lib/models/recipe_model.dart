import 'package:siresep/core/utils/model_parsers.dart';

import 'ingredient_model.dart';

class RecipeModel {
  final String id;

  final String title;

  final String description;

  final String imageUrl;

  final String categoryId;

  final String categoryName;

  final String cuisine;

  final int cookTimeMinutes;

  final String difficulty;

  final double ratingAverage;

  final int reviewCount;

  final int servings;

  final int calories;

  final bool isTrending;

  final List<IngredientModel> ingredients;

  final List<String> instructions;

  final String createdBy;

  final DateTime createdAt;

  final DateTime updatedAt;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    required this.cuisine,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.ratingAverage,
    required this.reviewCount,
    required this.servings,
    required this.calories,
    required this.isTrending,
    required this.ingredients,
    required this.instructions,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecipeModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return RecipeModel(
      id: map['id'] ?? '',

      title: map['title'] ?? '',

      description:
      map['description'] ?? '',

      imageUrl: map['imageUrl'] ?? '',

      categoryId:
      map['categoryId'] ?? '',

      categoryName:
      map['categoryName'] ?? '',

      cuisine: map['cuisine'] ?? '',

      cookTimeMinutes:
      ModelParsers.parseInt(
        map['cookTimeMinutes'],
      ),

      difficulty:
      map['difficulty'] ?? '',

      ratingAverage:
      ModelParsers.parseDouble(
        map['ratingAverage'],
      ),

      reviewCount:
      ModelParsers.parseInt(
        map['reviewCount'],
      ),

      servings:
      ModelParsers.parseInt(
        map['servings'],
      ),

      calories:
      ModelParsers.parseInt(
        map['calories'],
      ),

      isTrending:
      ModelParsers.parseBool(
        map['isTrending'],
      ),

      ingredients:
      (map['ingredients'] as List?)
          ?.map(
            (item) =>
            IngredientModel.fromMap(
              Map<String, dynamic>.from(
                item,
              ),
            ),
      )
          .toList() ??
          [],

      instructions:
      List<String>.from(
        map['instructions'] ?? [],
      ),

      createdBy:
      map['createdBy'] ?? '',

      createdAt:
      ModelParsers.parseDateTime(
        map['createdAt'],
      ),

      updatedAt:
      ModelParsers.parseDateTime(
        map['updatedAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'title': title,

      'description': description,

      'imageUrl': imageUrl,

      'categoryId': categoryId,

      'categoryName': categoryName,

      'cuisine': cuisine,

      'cookTimeMinutes':
      cookTimeMinutes,

      'difficulty': difficulty,

      'ratingAverage':
      ratingAverage,

      'reviewCount': reviewCount,

      'servings': servings,

      'calories': calories,

      'isTrending': isTrending,

      'ingredients':
      ingredients
          .map((e) => e.toMap())
          .toList(),

      'instructions': instructions,

      'createdBy': createdBy,

      'createdAt': createdAt,

      'updatedAt': updatedAt,
    };
  }

  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    String? cuisine,
    int? cookTimeMinutes,
    String? difficulty,
    double? ratingAverage,
    int? reviewCount,
    int? servings,
    int? calories,
    bool? isTrending,
    List<IngredientModel>? ingredients,
    List<String>? instructions,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,

      title: title ?? this.title,

      description:
      description ??
          this.description,

      imageUrl:
      imageUrl ?? this.imageUrl,

      categoryId:
      categoryId ??
          this.categoryId,

      categoryName:
      categoryName ??
          this.categoryName,

      cuisine:
      cuisine ?? this.cuisine,

      cookTimeMinutes:
      cookTimeMinutes ??
          this.cookTimeMinutes,

      difficulty:
      difficulty ??
          this.difficulty,

      ratingAverage:
      ratingAverage ??
          this.ratingAverage,

      reviewCount:
      reviewCount ??
          this.reviewCount,

      servings:
      servings ?? this.servings,

      calories:
      calories ?? this.calories,

      isTrending:
      isTrending ??
          this.isTrending,

      ingredients:
      ingredients ??
          this.ingredients,

      instructions:
      instructions ??
          this.instructions,

      createdBy:
      createdBy ??
          this.createdBy,

      createdAt:
      createdAt ??
          this.createdAt,

      updatedAt:
      updatedAt ??
          this.updatedAt,
    );
  }
}