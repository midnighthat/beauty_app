import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryPink,
                    AppColors.primaryPink.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleText(
                        'Total',
                        color: AppColors.white,
                        fontSize: 24,
                      ),
                      const TitleText(
                        '\$238.00',
                        color: AppColors.white,
                        fontSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Product list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Product items
                    Expanded(
                      child: ListView(
                        children: [
                          _buildCartItem(
                            'Flowerbomb Eau de Parfum Spray',
                            'Color',
                            '\$85.00',
                            1,
                            'assets/images/product1.png',
                          ),
                          const SizedBox(height: 16),
                          _buildCartItem(
                            'Lady Avebury',
                            'Color',
                            '\$69.00',
                            1,
                            'assets/images/product2.png',
                          ),
                          const SizedBox(height: 16),
                          _buildCartItem(
                            'Au The Vert',
                            'Color',
                            '\$59.00',
                            1,
                            'assets/images/product3.png',
                          ),
                          const SizedBox(height: 16),
                          _buildCartItem(
                            'Lucifer Eau De Perfume',
                            'Color',
                            '\$45.00',
                            1,
                            'assets/images/product4.png',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Continue button
                    PrimaryButton(
                      text: 'Continue',
                      onPressed: () {
                        // TODO: Implement checkout flow
                      },
                      width: double.infinity,
                      size: ButtonSize.large,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
    String name,
    String color,
    String price,
    int quantity,
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: AppColors.primaryPink,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  name,
                  type: TextType.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                CustomText(
                  color,
                  type: TextType.caption,
                  color: AppColors.lightText,
                ),
                const SizedBox(height: 12),
                // Quantity controls
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Decrease quantity
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.primaryPink,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomText(
                      quantity.toString(),
                      type: TextType.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // TODO: Increase quantity
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.primaryPink,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price
          CustomText(
            price,
            type: TextType.bodyLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryPink,
          ),
        ],
      ),
    );
  }
}