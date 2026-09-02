import 'package:flutter/material.dart';

import '../models/nav_item_model.dart';
import '../widgets/custom_nav_bar.dart';

import '../screens/home_screen.dart';
import '../screens/tools_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ToolsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  final List<NavItemModel> _navItems = const [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavItemModel(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      label: 'Tools',
    ),
    NavItemModel(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
    ),
    NavItemModel(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
