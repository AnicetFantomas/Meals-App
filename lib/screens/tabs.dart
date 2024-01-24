import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false,
  };

class TabsSCreen extends StatefulWidget {
  const TabsSCreen({super.key});

  @override
  State<TabsSCreen> createState() => _TabsSCreenState();
}

class _TabsSCreenState extends State<TabsSCreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoritesMeals = [];
  Map<Filter, bool> _selectFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
     final result = await Navigator.of(context)
          .push<Map<Filter, bool>>(MaterialPageRoute(builder: (ctx) =>  FiltersScreen(currentFilters: _selectFilters,)));
      setState(() {
        _selectFilters = result ?? _selectFilters;
      });
    }
  }

  @override
  
  Widget build(BuildContext context) {

    final availableMeals = dummyMeals.where((meal) {
    if (_selectFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (_selectFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (_selectFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    if (_selectFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoritesMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
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
