import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';

class TabsSCreen extends StatefulWidget {
   const TabsSCreen({super.key});

  @override
  State<TabsSCreen> createState() => _TabsSCreenState();
}

class _TabsSCreenState extends State<TabsSCreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoritesMeals = [];

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExising = _favoritesMeals.contains(meal);

    if (isExising) {
      setState(() {
        _favoritesMeals.remove(meal);
      });
    } else {
      setState(() {
        _favoritesMeals.add(meal);
      });
    }
  }

  void setSelectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage =  CategoriesScreen(onToggleFavorite: _toggleMealFavoriteStatus,);
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage =  MealsScreen(meals: [], onToggleFavorite: _toggleMealFavoriteStatus,);
      activePageTitle = 'Favorites';
    }


    return Scaffold(
      appBar: AppBar(
        title:  Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: setSelectedPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}