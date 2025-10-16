import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../../providers/budget_provider.dart';
import '../../widgets/products/product_cards.dart';
import '../../widgets/products/cart_utils.dart';
import '../../widgets/common/budget_dialogs.dart';
import '../cart/cart_screen.dart';

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _ProductsHeader(isDark: isDark),
              
              const SizedBox(height: 16),
              
              // Title
              _ProductsTitle(isDark: isDark),

              const SizedBox(height: 24),

              // Category Filter Pills
              const _CategoryFilter(),

              const SizedBox(height: 32),

              // Suggested Products Section
              const _SuggestedProductsSection(),

              const SizedBox(height: 32),

              // Recent Products Section
              const _RecentProductsSection(),

              // Bottom padding for tab bar
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

// Header widget with cart icon
class _ProductsHeader extends ConsumerWidget {
  final bool isDark;
  
  const _ProductsHeader({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBudget = ref.watch(hasBudgetSetupProvider);
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: AppColors.primaryBrown,
              size: 20,
            ),
          ),
          
          // Budget status and Cart Icon
          Row(
            children: [
              // Budget status indicator
              if (!hasBudget) ...[
                GestureDetector(
                  onTap: () => BudgetDialogs.showBudgetSetupDialog(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Set Budget',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              
              // Cart Icon with badge
              const _CartIcon(),
            ],
          ),
        ],
      ),
    );
  }
}

// Cart icon with badge - optimized to only rebuild when cart count changes
class _CartIcon extends ConsumerWidget {
  const _CartIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartItemCount = ref.watch(cartItemCountProvider);
    
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 28,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
        ),
        // Cart item count badge - only shows when count > 0
        if (cartItemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primaryBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                cartItemCount.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Products title
class _ProductsTitle extends StatelessWidget {
  final bool isDark;
  
  const _ProductsTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Discover Our Product',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
          height: 1.2,
        ),
      ),
    );
  }
}

// Category filter - rebuilds only when selected category changes
class _CategoryFilter extends ConsumerWidget {
  const _CategoryFilter();

  static const categories = [
    'All', 'Cleanser', 'Moisturizer', 'Sunscreen', 'Serum', 'Toner', 'Exfoliator', 'Face Mask'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBrown : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primaryBrown : AppColors.lightText.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                    ? AppColors.white 
                    : (isDark ? AppColors.creamBackground : AppColors.darkText),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Suggested products section - rebuilds only when skin profile changes
class _SuggestedProductsSection extends ConsumerWidget {
  const _SuggestedProductsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Section header
        _SuggestedProductsHeader(isDark: isDark),
        
        const SizedBox(height: 16),
        
        // Products grid
        _SuggestedProductsGrid(isDark: isDark),
      ],
    );
  }
}

// Suggested products header - rebuilt only when skin profile changes
class _SuggestedProductsHeader extends ConsumerWidget {
  final bool isDark;
  
  const _SuggestedProductsHeader({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skinProfile = ref.watch(skinProfileProvider.select((profile) => profile?.skinType));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suggested for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on your ${skinProfile ?? "skin"} profile',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// Suggested products grid - rebuilds only when suggested products change
class _SuggestedProductsGrid extends ConsumerWidget {
  final bool isDark;
  
  const _SuggestedProductsGrid({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedProducts = ref.watch(suggestedProductsProvider);

    return SizedBox(
      height: 280,
      child: suggestedProducts.when(
        data: (products) {
          final limitedProducts = products.take(4).toList();
          
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: limitedProducts.length,
            itemBuilder: (context, index) {
              final product = limitedProducts[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                child: ProductCard(
                  product: product,
                  showSuggestedBadge: true,
                  onAddToCart: () => CartUtils.addProductToCart(ref, context, product),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBrown),
        ),
        error: (error, stack) => Center(
          child: Text('Error loading products: $error'),
        ),
      ),
    );
  }
}

// Recent products section
class _RecentProductsSection extends ConsumerWidget {
  const _RecentProductsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Product',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Products list
        _RecentProductsList(isDark: isDark),
      ],
    );
  }
}

// Recent products list - rebuilds when category or limit changes
class _RecentProductsList extends ConsumerWidget {
  final bool isDark;
  
  const _RecentProductsList({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final recentProductsLimit = ref.watch(recentProductsLimitProvider);
    final categoryMapping = ref.watch(categoryMappingProvider);
    
    // Get actual category for the selected UI category
    final actualCategory = categoryMapping[selectedCategory] ?? 'Cleanser';
    final productsAsync = ref.watch(asyncProductsByCategoryProvider(actualCategory));

    return productsAsync.when(
      data: (allProducts) {
        final recentProducts = allProducts.skip(4).take(recentProductsLimit).toList();
        final hasMoreProducts = allProducts.length > (4 + recentProductsLimit);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Product items
              ...recentProducts.map((product) => ProductListItem(
                product: product,
                onAddToCart: () => CartUtils.addProductToCart(ref, context, product),
              )),
              
              // Load more button
              if (hasMoreProducts)
                _LoadMoreButton(
                  onPressed: () {
                    ref.read(recentProductsLimitProvider.notifier).state += 3;
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBrown),
      ),
      error: (error, stack) => Center(
        child: Text('Error loading products: $error'),
      ),
    );
  }
}

// Load more button
class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const _LoadMoreButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryBrown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBrown.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Text(
            'Load More Products',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBrown,
            ),
          ),
        ),
      ),
    );
  }
}