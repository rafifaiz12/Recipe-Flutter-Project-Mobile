import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep/models/recipe_model.dart';

class RecipeDetailService {
  final CollectionReference<Map<String, dynamic>> _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<RecipeModel?> getRecipeById(String recipeId) async {
    final doc = await _recipesCollection.doc(recipeId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return RecipeModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  Stream<RecipeModel?> getRecipeStreamById(String recipeId) {
    return _recipesCollection.doc(recipeId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return RecipeModel.fromMap({'id': doc.id, ...doc.data()!});
    });
  }
}
