import 'package:flutter/material.dart';
import '../../features/main/screens/discover_page.dart';
import '../../features/food_of_the_day/screens/food_of_the_day_page.dart';
import '../../features/meal_plan/screens/meal_plan_page.dart';
import '../../features/comparison/screens/comparison_page.dart';
import '../../features/blog/screens/blog_page.dart';
import '../../features/profiles/screens/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Discover',
    'Food of the Day',
    'Meal Plan',
    'Compare',
    'Blog',
    'Profile',
  ];

  static const List<Widget> _pages = [
    DiscoverPage(),
    FoodOfTheDayPage(),
    MealPlanPage(),
    ComparisonPage(),
    BlogPage(),
    ProfilePage(),
  ];

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Spoonfed',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            _drawerItem(0, Icons.explore, 'Discover'),
            _drawerItem(1, Icons.restaurant, 'Food of the Day'),
            _drawerItem(2, Icons.calendar_today, 'Meal Plan'),
            _drawerItem(3, Icons.compare_arrows, 'Comparison'),
            _drawerItem(4, Icons.article, 'Blog'),
            _drawerItem(5, Icons.person, 'Profile'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Daily'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Plan'),
          NavigationDestination(icon: Icon(Icons.compare_arrows), label: 'Compare'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Blog'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _drawerItem(int index, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      onTap: () {
        _selectPage(index);
        Navigator.pop(context);
      },
    );
  }
}
