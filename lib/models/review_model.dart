import 'package:siresep/core/utils/model_parsers.dart';

class ReviewModel {
  final String id;

  final String recipeId;

  final String userId;

  final String userName;

  final String userPhotoUrl;

  final int rating;

  final String comment;

  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return ReviewModel(
      id: map['id'] ?? '',
      recipeId: map['recipeId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl:
      map['userPhotoUrl'] ?? '',
      rating: ModelParsers.parseInt(
        map['rating'],
      ),
      comment: map['comment'] ?? '',
      createdAt:
      ModelParsers.parseDateTime(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? recipeId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      recipeId:
      recipeId ?? this.recipeId,
      userId: userId ?? this.userId,
      userName:
      userName ?? this.userName,
      userPhotoUrl:
      userPhotoUrl ??
          this.userPhotoUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt:
      createdAt ?? this.createdAt,
    );
  }
}