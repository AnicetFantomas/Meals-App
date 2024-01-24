import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsSCreen extends StatefulWidget {
   const TabsSCreen({super.key});

  @override
  State<TabsSCreen> createState() => _TabsSCreenState();
}

class _TabsSCreenState extends State<TabsSCreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoritesMeals = [];

  void _showInfoMessage(String message) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        )
      );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExising = _favoritesMeals.contains(meal);

    if (isExising) {
      setState(() {
        _favoritesMeals.remove(meal);
      });
        _showInfoMessage('Meal is no longer a favorite');

    } else {
      setState(() {
        _favoritesMeals.add(meal);
        _showInfoMessage('Marked as a favorite!');
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
      activePage =  MealsScreen(meals: _favoritesMeals, onToggleFavorite: _toggleMealFavoriteStatus,);
      activePageTitle = 'Favorites';
    }


    return Scaffold(
      appBar: AppBar(
        title:  Text(activePageTitle),
      ),
      drawer: const MainDrawer(),
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