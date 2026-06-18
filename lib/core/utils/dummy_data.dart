import 'package:siresep/models/category_model.dart';
import 'package:siresep/models/favorite_model.dart';
import 'package:siresep/models/ingredient_model.dart';
import 'package:siresep/models/meal_plan_model.dart';
import 'package:siresep/models/recipe_model.dart';
import 'package:siresep/models/review_model.dart';
import 'package:siresep/models/shopping_item_model.dart';
import 'package:siresep/models/user_model.dart';

class DummyData {
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'Bagus Prasetyo',
    email: 'bagus@example.com',
    photoUrl: '',
    role: 'user',
    dietaryPreferences: ['High Protein', 'Low Sugar'],
    createdAt: DateTime.now(),
  );

  static final List<CategoryModel> categories = [
    CategoryModel(id: 'cat_001', name: 'All', icon: 'apps'),

    CategoryModel(id: 'cat_002', name: 'Breakfast', icon: 'free_breakfast'),

    CategoryModel(id: 'cat_003', name: 'Lunch', icon: 'lunch_dining'),

    CategoryModel(id: 'cat_004', name: 'Dinner', icon: 'dinner_dining'),

    CategoryModel(id: 'cat_005', name: 'Dessert', icon: 'icecream'),

    CategoryModel(id: 'cat_006', name: 'Healthy', icon: 'eco'),
  ];

  static final List<RecipeModel> recipes = [
    RecipeModel(
      id: 'recipe_001',

      title: 'Creamy Pasta Carbonara',

      description:
          'Pasta creamy klasik dengan saus telur, parmesan, dan beef bacon.',

      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?q=80&w=1200&auto=format&fit=crop',

      categoryId: 'cat_004',

      categoryName: 'Dinner',

      dishType: 'Makanan Utama',
      cuisine: 'Italian',
      mealType: 'Dinner',
      dietType: 'Regular',

      cookTimeMinutes: 25,

      difficulty: 'Easy',

      ratingAverage: 4.8,

      reviewCount: 234,

      servings: 2,

      calories: 540,

      isTrending: true,

      createdBy: currentUser.id,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      ingredients: [
        IngredientModel(name: 'Spaghetti', quantity: 200, unit: 'g'),

        IngredientModel(name: 'Egg', quantity: 2, unit: 'pcs'),

        IngredientModel(name: 'Parmesan Cheese', quantity: 50, unit: 'g'),

        IngredientModel(name: 'Beef Bacon', quantity: 100, unit: 'g'),

        IngredientModel(name: 'Black Pepper', quantity: 1, unit: 'tsp'),
      ],

      instructions: [
        'Cook spaghetti until al dente.',

        'Cook beef bacon until crispy.',

        'Mix egg and parmesan cheese.',

        'Combine pasta with bacon and sauce mixture.',

        'Serve while warm.',
      ],
    ),

    RecipeModel(
      id: 'recipe_002',

      title: 'Grilled Salmon Bowl',

      description: 'Healthy grilled salmon bowl with vegetables and rice.',

      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=1200&auto=format&fit=crop',

      categoryId: 'cat_006',

      categoryName: 'Healthy',

      dishType: 'Makanan Utama',
      cuisine: 'Japanese',
      mealType: 'Lunch',
      dietType: 'High Protein',

      cookTimeMinutes: 35,

      difficulty: 'Medium',

      ratingAverage: 4.9,

      reviewCount: 180,

      servings: 2,

      calories: 430,

      isTrending: true,

      createdBy: currentUser.id,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      ingredients: [
        IngredientModel(name: 'Salmon Fillet', quantity: 2, unit: 'pcs'),

        IngredientModel(name: 'Rice', quantity: 200, unit: 'g'),

        IngredientModel(name: 'Broccoli', quantity: 100, unit: 'g'),

        IngredientModel(name: 'Carrot', quantity: 1, unit: 'pcs'),

        IngredientModel(name: 'Olive Oil', quantity: 2, unit: 'tbsp'),
      ],

      instructions: [
        'Season salmon with salt and pepper.',

        'Grill salmon until cooked.',

        'Steam vegetables.',

        'Prepare rice bowl.',

        'Serve salmon on top of rice and vegetables.',
      ],
    ),

    RecipeModel(
      id: 'recipe_003',

      title: 'Chicken Caesar Salad',

      description:
          'Fresh romaine lettuce with grilled chicken and creamy caesar dressing.',

      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1200&auto=format&fit=crop',

      categoryId: 'cat_006',

      categoryName: 'Healthy',

      dishType: 'Makanan Utama',
      cuisine: 'Western',
      mealType: 'Lunch',
      dietType: 'Regular',

      cookTimeMinutes: 20,

      difficulty: 'Easy',

      ratingAverage: 4.7,

      reviewCount: 145,

      servings: 2,

      calories: 320,

      isTrending: false,

      createdBy: currentUser.id,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      ingredients: [
        IngredientModel(name: 'Chicken Breast', quantity: 200, unit: 'g'),

        IngredientModel(name: 'Romaine Lettuce', quantity: 1, unit: 'pcs'),

        IngredientModel(name: 'Caesar Dressing', quantity: 3, unit: 'tbsp'),

        IngredientModel(name: 'Croutons', quantity: 50, unit: 'g'),

        IngredientModel(name: 'Parmesan Cheese', quantity: 30, unit: 'g'),
      ],

      instructions: [
        'Grill chicken breast until cooked.',

        'Cut lettuce into bite-size pieces.',

        'Mix lettuce with dressing.',

        'Add chicken and croutons.',

        'Top with parmesan cheese.',
      ],
    ),

    RecipeModel(
      id: 'recipe_004',

      title: 'Classic Pancakes',

      description: 'Soft fluffy pancakes perfect for breakfast.',

      imageUrl:
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?q=80&w=1200&auto=format&fit=crop',

      categoryId: 'cat_002',

      categoryName: 'Breakfast',

      dishType: 'Dessert',
      cuisine: 'American',
      mealType: 'Breakfast',
      dietType: 'Regular',

      cookTimeMinutes: 15,

      difficulty: 'Easy',

      ratingAverage: 4.6,

      reviewCount: 201,

      servings: 3,

      calories: 410,

      isTrending: false,

      createdBy: currentUser.id,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      ingredients: [
        IngredientModel(name: 'Flour', quantity: 250, unit: 'g'),

        IngredientModel(name: 'Milk', quantity: 200, unit: 'ml'),

        IngredientModel(name: 'Egg', quantity: 1, unit: 'pcs'),

        IngredientModel(name: 'Sugar', quantity: 2, unit: 'tbsp'),

        IngredientModel(name: 'Baking Powder', quantity: 1, unit: 'tsp'),
      ],

      instructions: [
        'Mix dry ingredients.',

        'Add milk and egg.',

        'Whisk until smooth.',

        'Cook batter on pan.',

        'Serve with syrup.',
      ],
    ),
  ];

  static final List<ReviewModel> reviews = [
    ReviewModel(
      id: 'review_001',

      recipeId: 'recipe_001',

      userId: 'user_002',

      userName: 'Sarah Johnson',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',

      rating: 5,

      comment:
          'Absolutely delicious! The pasta was creamy and flavorful. Definitely making this again.',

      createdAt: DateTime.parse('2025-05-01'),
    ),

    ReviewModel(
      id: 'review_002',

      recipeId: 'recipe_001',

      userId: 'user_003',

      userName: 'Michael Lee',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop',

      rating: 4,

      comment:
          'Very tasty recipe. I added extra parmesan cheese and it turned out amazing.',

      createdAt: DateTime.parse('2025-05-03'),
    ),

    ReviewModel(
      id: 'review_003',

      recipeId: 'recipe_002',

      userId: 'user_004',

      userName: 'Amanda Wilson',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=400&auto=format&fit=crop',

      rating: 5,

      comment:
          'Healthy and super easy to prepare. The salmon was perfectly juicy.',

      createdAt: DateTime.parse('2025-05-05'),
    ),

    ReviewModel(
      id: 'review_004',

      recipeId: 'recipe_002',

      userId: 'user_005',

      userName: 'Daniel Kim',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop',

      rating: 4,

      comment:
          'Great healthy meal option. I replaced broccoli with asparagus and it still worked perfectly.',

      createdAt: DateTime.parse('2025-05-08'),
    ),

    ReviewModel(
      id: 'review_005',

      recipeId: 'recipe_003',

      userId: 'user_006',

      userName: 'Jessica Brown',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto=format&fit=crop',

      rating: 5,

      comment: 'Fresh, light, and delicious. Perfect for lunch.',

      createdAt: DateTime.parse('2025-05-10'),
    ),

    ReviewModel(
      id: 'review_006',

      recipeId: 'recipe_004',

      userId: 'user_007',

      userName: 'Ryan Martinez',

      userPhotoUrl:
          'https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=400&auto=format&fit=crop',

      rating: 5,

      comment: 'These pancakes were incredibly fluffy. My family loved them.',

      createdAt: DateTime.parse('2025-05-12'),
    ),
  ];

  static final List<FavoriteModel> favorites = [];

  static final List<MealPlanModel> mealPlans = [
    MealPlanModel(
      id: 'meal_001',
      userId: 'user_001',
      day: 'Mon',
      mealType: 'Breakfast',
      recipeId: 'recipe_001',
      createdAt: DateTime.now(),
    ),
  ];

  static final List<ShoppingItemModel> shoppingItems = [];

  static List<RecipeModel> get trendingRecipes {
    return recipes.where((recipe) => recipe.isTrending).toList();
  }

  static List<RecipeModel> get favoriteRecipes {
    final favoriteIds = favorites.map((favorite) => favorite.recipeId).toList();

    return recipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
  }

  static RecipeModel? recipeById(String recipeId) {
    try {
      return recipes.firstWhere((recipe) => recipe.id == recipeId);
    } catch (_) {
      return null;
    }
  }

  static List<ReviewModel> reviewsByRecipeId(String recipeId) {
    return reviews.where((review) => review.recipeId == recipeId).toList();
  }

  static bool isFavorite(String recipeId) {
    return favorites.any((favorite) => favorite.recipeId == recipeId);
  }

  static void toggleFavorite(String recipeId) {
    final existingIndex = favorites.indexWhere(
      (favorite) => favorite.recipeId == recipeId,
    );

    if (existingIndex != -1) {
      favorites.removeAt(existingIndex);

      return;
    }

    favorites.add(
      FavoriteModel(
        id: 'favorite_${DateTime.now().microsecondsSinceEpoch}',
        userId: currentUser.id,
        recipeId: recipeId,
        createdAt: DateTime.now(),
      ),
    );
  }
}
