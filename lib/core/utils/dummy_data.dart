class DummyData {
  static const Map<String, dynamic> currentUser = {
    'id': 'user_001',
    'name': 'Bagus Prasetyo',
    'email': 'bagus@example.com',
    'photoUrl': '',
    'role': 'user',
    'dietaryPreferences': ['High Protein', 'Low Sugar'],
  };

  static const List<Map<String, dynamic>> categories = [
    {'id': 'cat_001', 'name': 'All', 'icon': 'apps'},
    {'id': 'cat_002', 'name': 'Breakfast', 'icon': 'free_breakfast'},
    {'id': 'cat_003', 'name': 'Lunch', 'icon': 'lunch_dining'},
    {'id': 'cat_004', 'name': 'Dinner', 'icon': 'dinner_dining'},
    {'id': 'cat_005', 'name': 'Dessert', 'icon': 'icecream'},
    {'id': 'cat_006', 'name': 'Healthy', 'icon': 'eco'},
  ];

  static const List<Map<String, dynamic>> recipes = [
    {
      'id': 'recipe_001',
      'title': 'Creamy Pasta Carbonara',
      'description':
          'Pasta creamy klasik dengan telur, parmesan, dan bacon yang gurih.',
      'imageUrl':
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?q=80&w=1200&auto=format&fit=crop',
      'categoryId': 'cat_004',
      'categoryName': 'Dinner',
      'cuisine': 'Western',
      'cookTimeMinutes': 25,
      'difficulty': 'Easy',
      'ratingAverage': 4.8,
      'reviewCount': 234,
      'servings': 2,
      'calories': 540,
      'isTrending': true,
      'ingredients': [
        {'name': 'Spaghetti', 'quantity': 200.0, 'unit': 'g'},
        {'name': 'Eggs', 'quantity': 2.0, 'unit': 'pcs'},
        {'name': 'Parmesan cheese', 'quantity': 50.0, 'unit': 'g'},
        {'name': 'Bacon', 'quantity': 100.0, 'unit': 'g'},
        {'name': 'Black pepper', 'quantity': 0.5, 'unit': 'tsp'},
      ],
      'instructions': [
        'Cook spaghetti in salted boiling water until al dente.',
        'Fry bacon until crispy, then set aside.',
        'Beat eggs with parmesan and black pepper.',
        'Drain pasta, mix with bacon and egg mixture.',
        'Serve immediately with extra parmesan.',
      ],
    },
    {
      'id': 'recipe_002',
      'title': 'Grilled Salmon with Herbs',
      'description':
          'Salmon panggang dengan aroma lemon dan herbs segar, cocok untuk makan malam sehat.',
      'imageUrl':
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=1200&auto=format&fit=crop',
      'categoryId': 'cat_004',
      'categoryName': 'Dinner',
      'cuisine': 'Western',
      'cookTimeMinutes': 30,
      'difficulty': 'Medium',
      'ratingAverage': 4.9,
      'reviewCount': 180,
      'servings': 2,
      'calories': 420,
      'isTrending': true,
      'ingredients': [
        {'name': 'Salmon fillet', 'quantity': 2.0, 'unit': 'pcs'},
        {'name': 'Lemon', 'quantity': 1.0, 'unit': 'pcs'},
        {'name': 'Olive oil', 'quantity': 2.0, 'unit': 'tbsp'},
        {'name': 'Parsley', 'quantity': 1.0, 'unit': 'tbsp'},
        {'name': 'Salt', 'quantity': 0.5, 'unit': 'tsp'},
      ],
      'instructions': [
        'Season salmon with salt, olive oil, and herbs.',
        'Heat grill pan over medium heat.',
        'Cook salmon for 4-5 minutes each side.',
        'Add lemon slices while grilling.',
        'Serve warm with vegetables.',
      ],
    },
    {
      'id': 'recipe_003',
      'title': 'Mediterranean Bowl',
      'description':
          'Mangkuk sehat berisi sayuran segar, protein, dan saus ringan ala Mediterania.',
      'imageUrl':
          'https://images.unsplash.com/photo-1547592180-85f173990554?q=80&w=1200&auto=format&fit=crop',
      'categoryId': 'cat_003',
      'categoryName': 'Lunch',
      'cuisine': 'Asian',
      'cookTimeMinutes': 20,
      'difficulty': 'Easy',
      'ratingAverage': 4.7,
      'reviewCount': 145,
      'servings': 1,
      'calories': 380,
      'isTrending': false,
      'ingredients': [
        {'name': 'Lettuce', 'quantity': 100.0, 'unit': 'g'},
        {'name': 'Cherry tomatoes', 'quantity': 8.0, 'unit': 'pcs'},
        {'name': 'Cucumber', 'quantity': 0.5, 'unit': 'pcs'},
        {'name': 'Chickpeas', 'quantity': 100.0, 'unit': 'g'},
        {'name': 'Feta cheese', 'quantity': 40.0, 'unit': 'g'},
      ],
      'instructions': [
        'Wash and prepare all vegetables.',
        'Arrange lettuce, cucumber, and tomatoes in a bowl.',
        'Add chickpeas and feta cheese on top.',
        'Drizzle with olive oil and lemon dressing.',
        'Serve fresh.',
      ],
    },
    {
      'id': 'recipe_004',
      'title': 'Banana Pancakes',
      'description':
          'Pancake lembut dengan rasa pisang alami, cocok untuk sarapan cepat.',
      'imageUrl':
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?q=80&w=1200&auto=format&fit=crop',
      'categoryId': 'cat_002',
      'categoryName': 'Breakfast',
      'cuisine': 'Western',
      'cookTimeMinutes': 15,
      'difficulty': 'Easy',
      'ratingAverage': 4.6,
      'reviewCount': 98,
      'servings': 2,
      'calories': 300,
      'isTrending': false,
      'ingredients': [
        {'name': 'Banana', 'quantity': 2.0, 'unit': 'pcs'},
        {'name': 'Eggs', 'quantity': 2.0, 'unit': 'pcs'},
        {'name': 'Flour', 'quantity': 120.0, 'unit': 'g'},
        {'name': 'Milk', 'quantity': 150.0, 'unit': 'ml'},
      ],
      'instructions': [
        'Mash bananas in a bowl.',
        'Mix with eggs, milk, and flour until smooth.',
        'Pour batter onto a non-stick pan.',
        'Cook each side until golden brown.',
        'Serve with honey or fruits.',
      ],
    },
    {
      'id': 'recipe_005',
      'title': 'Avocado Toast',
      'description':
          'Roti panggang renyah dengan alpukat lembut dan topping sederhana.',
      'imageUrl':
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=1200&auto=format&fit=crop',
      'categoryId': 'cat_002',
      'categoryName': 'Breakfast',
      'cuisine': 'Asian',
      'cookTimeMinutes': 10,
      'difficulty': 'Easy',
      'ratingAverage': 4.5,
      'reviewCount': 77,
      'servings': 1,
      'calories': 250,
      'isTrending': true,
      'ingredients': [
        {'name': 'Bread', 'quantity': 2.0, 'unit': 'slices'},
        {'name': 'Avocado', 'quantity': 1.0, 'unit': 'pcs'},
        {'name': 'Salt', 'quantity': 0.25, 'unit': 'tsp'},
        {'name': 'Chili flakes', 'quantity': 0.25, 'unit': 'tsp'},
      ],
      'instructions': [
        'Toast bread until crisp.',
        'Mash avocado with salt.',
        'Spread avocado on bread.',
        'Top with chili flakes and serve.',
      ],
    },
  ];

  static const List<Map<String, dynamic>> reviews = [
    {
      'id': 'review_001',
      'recipeId': 'recipe_001',
      'userName': 'Sarah M.',
      'rating': 5,
      'comment': 'Best carbonara recipe I have tried! So creamy and delicious.',
      'createdAt': '2025-09-20',
    },
    {
      'id': 'review_002',
      'recipeId': 'recipe_001',
      'userName': 'John D.',
      'rating': 4,
      'comment': 'Great recipe, though I added a bit more cheese.',
      'createdAt': '2025-09-15',
    },
    {
      'id': 'review_003',
      'recipeId': 'recipe_002',
      'userName': 'Nadia',
      'rating': 5,
      'comment': 'Fresh, healthy, and very easy to make.',
      'createdAt': '2025-09-19',
    },
    {
      'id': 'review_004',
      'recipeId': 'recipe_003',
      'userName': 'Rafi',
      'rating': 4,
      'comment': 'Simple and healthy lunch option.',
      'createdAt': '2025-09-17',
    },
  ];

  static final List<String> favoriteRecipeIds = ['recipe_001', 'recipe_003'];

  static final List<Map<String, dynamic>> mealPlans = [
    {
      'id': 'meal_001',
      'day': 'Mon',
      'mealType': 'Breakfast',
      'recipeId': 'recipe_004',
    },
    {
      'id': 'meal_002',
      'day': 'Mon',
      'mealType': 'Lunch',
      'recipeId': 'recipe_003',
    },
    {
      'id': 'meal_003',
      'day': 'Mon',
      'mealType': 'Dinner',
      'recipeId': 'recipe_001',
    },
    {
      'id': 'meal_004',
      'day': 'Tue',
      'mealType': 'Breakfast',
      'recipeId': 'recipe_005',
    },
  ];

  static final List<Map<String, dynamic>> shoppingItems = [];

  static bool isFavorite(String recipeId) {
    return favoriteRecipeIds.contains(recipeId);
  }

  static void addFavorite(String recipeId) {
    if (!favoriteRecipeIds.contains(recipeId)) {
      favoriteRecipeIds.add(recipeId);
    }
  }

  static void removeFavorite(String recipeId) {
    favoriteRecipeIds.remove(recipeId);
  }

  static void toggleFavorite(String recipeId) {
    if (isFavorite(recipeId)) {
      removeFavorite(recipeId);
    } else {
      addFavorite(recipeId);
    }
  }

  static List<Map<String, dynamic>> get trendingRecipes {
    return recipes.where((recipe) => recipe['isTrending'] == true).toList();
  }

  static List<Map<String, dynamic>> get breakfastRecipes {
    return recipes
        .where((recipe) => recipe['categoryName'] == 'Breakfast')
        .toList();
  }

  static List<Map<String, dynamic>> get lunchRecipes {
    return recipes
        .where((recipe) => recipe['categoryName'] == 'Lunch')
        .toList();
  }

  static List<Map<String, dynamic>> get dinnerRecipes {
    return recipes
        .where((recipe) => recipe['categoryName'] == 'Dinner')
        .toList();
  }

  static List<Map<String, dynamic>> reviewsByRecipeId(String recipeId) {
    return reviews.where((review) => review['recipeId'] == recipeId).toList();
  }

  static Map<String, dynamic>? recipeById(String recipeId) {
    try {
      return recipes.firstWhere((recipe) => recipe['id'] == recipeId);
    } catch (_) {
      return null;
    }
  }

  static List<Map<String, dynamic>> get favoriteRecipes {
    return recipes
        .where((recipe) => favoriteRecipeIds.contains(recipe['id']))
        .toList();
  }

  static List<Map<String, dynamic>> mealPlansByDay(String day) {
    return mealPlans.where((meal) => meal['day'] == day).toList();
  }

  static Map<String, dynamic>? mealPlanByDayAndType(
    String day,
    String mealType,
  ) {
    try {
      return mealPlans.firstWhere(
        (meal) => meal['day'] == day && meal['mealType'] == mealType,
      );
    } catch (_) {
      return null;
    }
  }

  static void upsertMealPlan({
    required String day,
    required String mealType,
    required String recipeId,
  }) {
    final int index = mealPlans.indexWhere(
      (meal) => meal['day'] == day && meal['mealType'] == mealType,
    );

    final Map<String, dynamic> newItem = {
      'id': index == -1
          ? 'meal_${DateTime.now().microsecondsSinceEpoch}'
          : mealPlans[index]['id'],
      'day': day,
      'mealType': mealType,
      'recipeId': recipeId,
    };

    if (index == -1) {
      mealPlans.add(newItem);
      return;
    }

    mealPlans[index] = newItem;
  }

  static void removeMealPlan({required String day, required String mealType}) {
    mealPlans.removeWhere(
      (meal) => meal['day'] == day && meal['mealType'] == mealType,
    );
  }

  static List<Map<String, dynamic>> shoppingItemsByCategory(String category) {
    return shoppingItems.where((item) => item['category'] == category).toList();
  }

  static List<String> get shoppingCategories {
    return shoppingItems
        .map((item) => item['category'] as String)
        .toSet()
        .toList();
  }

  static String mapIngredientCategory(String name) {
    final String value = name.toLowerCase();

    if (value.contains('spaghetti') ||
        value.contains('flour') ||
        value.contains('bread')) {
      return 'Pasta & Grains';
    }

    if (value.contains('egg') ||
        value.contains('milk') ||
        value.contains('parmesan') ||
        value.contains('feta') ||
        value.contains('cheese') ||
        value.contains('yogurt')) {
      return 'Dairy & Eggs';
    }

    if (value.contains('bacon') ||
        value.contains('salmon') ||
        value.contains('chicken')) {
      return 'Meat & Fish';
    }

    return 'Fruits & Vegetables';
  }

  static String formatQuantity(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  static List<Map<String, dynamic>> get shoppingItemsSnapshot {
    return shoppingItems
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static void clearShoppingItems() {
    shoppingItems.clear();
  }

  static void addManualShoppingItem({
    required String name,
    required String quantity,
    required String unit,
    required String category,
  }) {
    addOrMergeShoppingItem({
      'id': 'manual_${DateTime.now().microsecondsSinceEpoch}',
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'isChecked': false,
      'isManual': true,
    });
  }

  static void addOrMergeShoppingItem(Map<String, dynamic> item) {
    final String name = item['name']?.toString() ?? '';
    final String quantity = item['quantity']?.toString() ?? '0';
    final String unit = item['unit']?.toString() ?? '';
    final String category = item['category']?.toString() ?? 'Others';
    final bool isChecked = item['isChecked'] as bool? ?? false;
    final bool isManual = item['isManual'] as bool? ?? false;

    final int existingIndex = shoppingItems.indexWhere(
      (existing) =>
          (existing['name'] as String).toLowerCase() == name.toLowerCase() &&
          existing['unit'] == unit &&
          existing['category'] == category,
    );

    if (existingIndex == -1) {
      shoppingItems.add({
        'id':
            item['id']?.toString() ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'category': category,
        'isChecked': isChecked,
        'isManual': isManual,
      });
      return;
    }

    final double currentQty =
        double.tryParse(shoppingItems[existingIndex]['quantity'].toString()) ??
        0;
    final double incomingQty = double.tryParse(quantity) ?? 0;

    shoppingItems[existingIndex]['quantity'] = formatQuantity(
      currentQty + incomingQty,
    );
    shoppingItems[existingIndex]['isChecked'] =
        (shoppingItems[existingIndex]['isChecked'] as bool) || isChecked;
  }

  static void removeShoppingItem(String id) {
    shoppingItems.removeWhere((item) => item['id'] == id);
  }

  static void toggleShoppingItem(String id) {
    final int index = shoppingItems.indexWhere((item) => item['id'] == id);

    if (index == -1) {
      return;
    }

    shoppingItems[index]['isChecked'] =
        !(shoppingItems[index]['isChecked'] as bool);
  }

  static void addRecipeIngredientsToShoppingList({
    required Map<String, dynamic> recipe,
    required int selectedServings,
  }) {
    final int baseServings = (recipe['servings'] as int?) ?? 1;
    final List<Map<String, dynamic>> ingredients =
        List<Map<String, dynamic>>.from(recipe['ingredients'] as List);

    for (final ingredient in ingredients) {
      final String name = ingredient['name'] as String? ?? '';
      final double baseQuantity = (ingredient['quantity'] as num).toDouble();
      final double scaledQuantity =
          (baseQuantity / baseServings) * selectedServings;
      final String unit = ingredient['unit'] as String? ?? '';

      addOrMergeShoppingItem({
        'id': 'recipe_${recipe['id']}_$name',
        'name': name,
        'quantity': formatQuantity(scaledQuantity),
        'unit': unit,
        'category': mapIngredientCategory(name),
        'isChecked': false,
        'isManual': false,
      });
    }
  }

  static void generateShoppingItemsFromMealPlans({required String day}) {
    clearShoppingItems();

    final List<Map<String, dynamic>> selectedMeals = mealPlansByDay(day);

    for (final meal in selectedMeals) {
      final String? recipeId = meal['recipeId'] as String?;
      if (recipeId == null) {
        continue;
      }

      final Map<String, dynamic>? recipe = recipeById(recipeId);
      if (recipe == null) {
        continue;
      }

      final int servings = (recipe['servings'] as int?) ?? 1;

      addRecipeIngredientsToShoppingList(
        recipe: recipe,
        selectedServings: servings,
      );
    }
  }
}
