import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:siresep/providers/auth_provider.dart';
import 'package:siresep/providers/recipe_provider.dart';
import 'package:siresep/providers/favorite_provider.dart';
import 'package:siresep/providers/recipe_detail_provider.dart';
import 'package:siresep/providers/shopping_list_provider.dart';
import 'package:siresep/providers/meal_plan_provider.dart';
import 'package:siresep/providers/profile_provider.dart';
import 'package:siresep/providers/ai_chat_provider.dart';
import 'package:siresep/providers/review_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeDetailProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
          ShoppingListProvider()
            ..loadItems(),
        ),
        ChangeNotifierProvider(
          create: (_) => MealPlanProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AiChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewProvider(),
        ),
      ],
      child: const SiResepApp(),
    ),
  );
}