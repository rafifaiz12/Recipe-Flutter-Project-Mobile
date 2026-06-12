import 'package:siresep/core/utils/model_parsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_model.dart';

DateTime _parseRecipeDate(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  return ModelParsers.parseDateTime(value);
}

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

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    final categories = map['categories'];

    String categoryName = map['categoryName']?.toString() ?? '';

    if (categoryName.isEmpty && categories is List && categories.isNotEmpty) {
      categoryName = categories.first.toString();
    }

    final rawIngredients = map['ingredients'];
    final parsedIngredients = <IngredientModel>[];

    if (rawIngredients is List) {
      for (final item in rawIngredients) {
        if (item is Map) {
          parsedIngredients.add(
            IngredientModel.fromMap(Map<String, dynamic>.from(item)),
          );
        } else {
          parsedIngredients.add(
            IngredientModel.fromMap({
              'name': item.toString(),
              'quantity': '',
              'unit': '',
            }),
          );
        }
      }
    }

    final rawInstructions = map['instructions'] ?? map['steps'];
    final instructions = <String>[];

    if (rawInstructions is List) {
      for (final item in rawInstructions) {
        instructions.add(item.toString());
      }
    }

    final rawRating = map['ratingAverage'] ?? map['rating'];
    final ratingAverage = rawRating == '—'
        ? 0.0
        : ModelParsers.parseDouble(rawRating);

    return RecipeModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      categoryName: categoryName,
      cuisine: map['cuisine']?.toString() ?? '',
      cookTimeMinutes: ModelParsers.parseInt(map['cookTimeMinutes']),
      difficulty: map['difficulty']?.toString() ?? '',
      ratingAverage: ratingAverage,
      reviewCount: ModelParsers.parseInt(map['reviewCount']),
      servings:
      ModelParsers.parseInt(
        map['servings'],
      ) <= 0
          ? 1
          : ModelParsers.parseInt(
        map['servings'],
      ),
      calories: ModelParsers.parseInt(map['calories']),
      isTrending: ModelParsers.parseBool(map['isTrending']),
      ingredients: parsedIngredients,
      instructions: instructions,
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: _parseRecipeDate(map['createdAt']),
      updatedAt: _parseRecipeDate(map['updatedAt']),
    );
  }

  factory RecipeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return RecipeModel.fromMap({
      ...data,
      'id': doc.id,
    });
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

      'cookTimeMinutes': cookTimeMinutes,

      'difficulty': difficulty,

      'ratingAverage': ratingAverage,

      'reviewCount': reviewCount,

      'servings': servings,

      'calories': calories,

      'isTrending': isTrending,

      'ingredients': ingredients.map((e) => e.toMap()).toList(),

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

      description: description ?? this.description,

      imageUrl: imageUrl ?? this.imageUrl,

      categoryId: categoryId ?? this.categoryId,

      categoryName: categoryName ?? this.categoryName,

      cuisine: cuisine ?? this.cuisine,

      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,

      difficulty: difficulty ?? this.difficulty,

      ratingAverage: ratingAverage ?? this.ratingAverage,

      reviewCount: reviewCount ?? this.reviewCount,

      servings: servings ?? this.servings,

      calories: calories ?? this.calories,

      isTrending: isTrending ?? this.isTrending,

      ingredients: ingredients ?? this.ingredients,

      instructions: instructions ?? this.instructions,

      createdBy: createdBy ?? this.createdBy,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
