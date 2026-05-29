import 'package:siresep/core/utils/model_parsers.dart';

class IngredientModel {
  final String name;

  final double quantity;

  final String unit;

  IngredientModel({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory IngredientModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return IngredientModel(
      name: map['name'] ?? '',
      quantity: ModelParsers.parseDouble(
        map['quantity'],
      ),
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  IngredientModel copyWith({
    String? name,
    double? quantity,
    String? unit,
  }) {
    return IngredientModel(
      name: name ?? this.name,
      quantity:
      quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}