import 'package:siresep/core/utils/model_parsers.dart';

class ShoppingItemModel {
  final String id;

  final String userId;

  final String name;

  final String quantity;

  final String unit;

  final String category;

  final bool isChecked;

  final bool isManual;

  final DateTime createdAt;

  ShoppingItemModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.isChecked,
    required this.isManual,
    required this.createdAt,
  });

  factory ShoppingItemModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return ShoppingItemModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      unit: map['unit'] ?? '',
      category: map['category'] ?? '',
      isChecked:
      ModelParsers.parseBool(
        map['isChecked'],
      ),
      isManual:
      ModelParsers.parseBool(
        map['isManual'],
      ),
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
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'isChecked': isChecked,
      'isManual': isManual,
      'createdAt': createdAt,
    };
  }

  ShoppingItemModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? quantity,
    String? unit,
    String? category,
    bool? isChecked,
    bool? isManual,
    DateTime? createdAt,
  }) {
    return ShoppingItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      quantity:
      quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category:
      category ?? this.category,
      isChecked:
      isChecked ?? this.isChecked,
      isManual:
      isManual ?? this.isManual,
      createdAt:
      createdAt ?? this.createdAt,
    );
  }
}