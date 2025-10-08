import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import 'custom_text.dart';

class SkinStatBar extends StatefulWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final Color? color;

  const SkinStatBar({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  State<SkinStatBar> createState() => _SkinStatBarState();
}

class _SkinStatBarState extends State<SkinStatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BodyText(
              widget.label,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1), // Spacer
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return CaptionText(
                          '${(_animation.value * 100).round()}%',
                          color: widget.color ?? AppColors.primaryPink,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: (widget.color ?? AppColors.primaryPink).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        widthFactor: _animation.value,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.color ?? AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}