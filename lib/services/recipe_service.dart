import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep/models/recipe_model.dart';

class RecipeService {
  final CollectionReference<Map<String, dynamic>> _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  bool _isPublished(Map<String, dynamic> data) {
    return data['status']?.toString().trim().toLowerCase() == 'published';
  }

  Future<List<RecipeModel>> getRecipes() async {
    final snapshot = await _recipesCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.where((doc) => _isPublished(doc.data())).map((doc) {
      return RecipeModel.fromMap({'id': doc.id, ...doc.data()});
    }).toList();
  }

  Stream<List<RecipeModel>> getRecipesStream() {
    return _recipesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.where((doc) => _isPublished(doc.data())).map((
            doc,
          ) {
            return RecipeModel.fromMap({'id': doc.id, ...doc.data()});
          }).toList();
        });
  }

  Future<List<RecipeModel>> getTrendingRecipes() async {
    final recipes = await getRecipes();
    return recipes.where((recipe) => recipe.isTrending).toList();
  }

  Future<List<RecipeModel>> searchRecipes(String query) async {
    final recipes = await getRecipes();
    final lowercaseQuery = query.toLowerCase();

    return recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowercaseQuery) ||
          recipe.categoryName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<RecipeModel?> getRecipeById(String id) async {
    final doc = await _recipesCollection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final data = doc.data()!;

    if (!_isPublished(data)) {
      return null;
    }

    return RecipeModel.fromMap({'id': doc.id, ...data});
  }
}
