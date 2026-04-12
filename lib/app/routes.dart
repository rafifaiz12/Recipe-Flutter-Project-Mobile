import 'package:flutter/material.dart';
import 'package:siresep/pages/auth/login_page.dart';
import 'package:siresep/pages/auth/register_page.dart';
import 'package:siresep/pages/main_navigation/main_navigation_page.dart';
import 'package:siresep/pages/home/home_page.dart';
import 'package:siresep/pages/search/search_page.dart';
import 'package:siresep/pages/favorites/favorites_page.dart';
import 'package:siresep/pages/meal_plan/meal_plan_page.dart';
import 'package:siresep/pages/shopping_list/shopping_list_page.dart';
import 'package:siresep/pages/profile/account_settings_page.dart';
import 'package:siresep/pages/profile/profile_page.dart';
import 'package:siresep/pages/recipe_detail/recipe_detail_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String mealPlan = '/meal-plan';
  static const String shoppingList = '/shopping-list';
  static const String profile = '/profile';
  static const String accountSettings = '/account-settings';
  static const String recipeDetail = '/recipe-detail';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      main: (context) => const MainNavigationPage(),
      home: (context) => const HomePage(),
      search: (context) => const SearchPage(),
      favorites: (context) => const FavoritesPage(),
      mealPlan: (context) => const MealPlanPage(),
      shoppingList: (context) => const ShoppingListPage(),
      profile: (context) => const ProfilePage(),
      accountSettings: (context) => const AccountSettingsPage(),
      recipeDetail: (context) => const RecipeDetailPage(),
    };
  }
}