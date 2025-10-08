import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 24),
            HeadingText(
              'Products Coming Soon',
              textAlign: TextAlign.center,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 16),
            BodyText(
              'We\'re working on bringing you the best K-Beauty products!',
              textAlign: TextAlign.center,
              color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
            ),
          ],
        ),
      ),
    );
  }
}