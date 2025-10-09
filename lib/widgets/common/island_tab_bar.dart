import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class IslandTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<TabItem> items;

  const IslandTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<IslandTabBar> createState() => _IslandTabBarState();
}

class _IslandTabBarState extends State<IslandTabBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    // Start the background animation loop
    _backgroundController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(IslandTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Container(
        height: 70,
        child: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryPink,
                    Color.lerp(
                      AppColors.primaryPink.withOpacity(0.8),
                      AppColors.primaryPink,
                      _backgroundAnimation.value * 0.3,
                    )!,
                  ],
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.items.length, (index) {
            final isSelected = index == widget.currentIndex;
            final item = widget.items[index];
            
            return GestureDetector(
              onTap: () => widget.onTap(index),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final scale = isSelected && _animationController.isAnimating
                      ? _scaleAnimation.value
                      : 1.0;
                  
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected 
                            ? AppColors.white.withOpacity(0.2)
                            : Colors.transparent,
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.white.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ] : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Icon
                          Icon(
                            item.icon,
                            color: AppColors.white,
                            size: 24,
                          ),
                          
                          // Active indicator dot
                          if (isSelected)
                            Positioned(
                              bottom: 6,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TabItem {
  final IconData icon;
  final String label;

  const TabItem({
    required this.icon,
    required this.label,
  });
}

// Predefined tab items for the beauty app
class BeautyTabs {
  static const List<TabItem> items = [
    TabItem(icon: Icons.home_outlined, label: 'Home'),
    TabItem(icon: Icons.shopping_bag_outlined, label: 'Products'),
    TabItem(icon: Icons.calendar_today_outlined, label: 'Appointment'),
    TabItem(icon: Icons.person_outline, label: 'Profile'),
  ];
}

// Alternative with Google Icons (if you prefer different icons)
class BeautyTabsAlt {
  static const List<TabItem> items = [
    TabItem(icon: Icons.home, label: 'Home'),
    TabItem(icon: Icons.self_improvement, label: 'Routine'), // Meditation/wellness icon
    TabItem(icon: Icons.store, label: 'Products'),
    TabItem(icon: Icons.person_outline, label: 'Profile'),
  ];
}