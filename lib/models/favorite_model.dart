import 'package:siresep/core/utils/model_parsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String id;

  final String userId;

  final String recipeId;

  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.createdAt,
  });

  factory FavoriteModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return FavoriteModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      recipeId: map['recipeId'] ?? '',
      createdAt:
      ModelParsers.parseDateTime(
        map['createdAt'],
      ),
    );
  }

  factory FavoriteModel.fromFirestore(
      Map<String, dynamic> map,
      ) {
    return FavoriteModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      recipeId: map['recipeId'] ?? '',
      createdAt: ModelParsers.parseDateTime(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
      'createdAt': createdAt,
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? recipeId,
    DateTime? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipeId:
      recipeId ?? this.recipeId,
      createdAt:
      createdAt ?? this.createdAt,
    );
  }
}