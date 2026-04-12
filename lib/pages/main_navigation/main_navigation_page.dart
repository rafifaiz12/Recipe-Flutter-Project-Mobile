import 'package:flutter/material.dart';
import 'package:siresep/core/widgets/custom_bottom_navbar.dart';
import 'package:siresep/pages/favorites/favorites_page.dart';
import 'package:siresep/pages/home/home_page.dart';
import 'package:siresep/pages/meal_plan/meal_plan_page.dart';
import 'package:siresep/pages/search/search_page.dart';
import 'package:siresep/pages/shopping_list/shopping_list_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    MealPlanPage(),
    ShoppingListPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}