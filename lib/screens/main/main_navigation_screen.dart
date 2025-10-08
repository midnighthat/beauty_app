import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/island_tab_bar.dart';
import 'home_tab.dart';
import 'products_tab.dart';
import 'booking_tab.dart';
import 'profile_tab.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const ProductsTab(),
    const BookingTab(),
    const ProfileTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
          // Custom island tab bar at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IslandTabBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: BeautyTabs.items,
            ),
          ),
        ],
      ),
    );
  }
}