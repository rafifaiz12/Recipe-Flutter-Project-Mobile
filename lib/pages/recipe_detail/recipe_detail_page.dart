import 'package:flutter/material.dart';
import 'package:siresep/core/utils/dummy_data.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeId = ModalRoute.of(context)?.settings.arguments as String?;
    final recipe = recipeId != null ? DummyData.recipeById(recipeId) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
      ),
      body: Center(
        child: Text(
          recipe != null ? recipe['title'] : 'Recipe Detail Page',
        ),
      ),
    );
  }
}