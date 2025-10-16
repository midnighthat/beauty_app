import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/cart_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../../providers/home_providers.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/product/product_details_screen.dart';
import '../../screens/main/main_navigation_screen.dart';

// Quiz prompt widget for users without profiles
class QuizPromptWidget extends StatelessWidget {
  final bool isDark;

  const QuizPromptWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 64,
                color: AppColors.primaryBrown,
              ),
            ),
            const SizedBox(height: 24),
            HeadingText(
              'Complete Your Skin Assessment',
              textAlign: TextAlign.center,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 16),
            BodyText(
              'Take our comprehensive skin quiz to get your personalized routine and see your skin report.',
              textAlign: TextAlign.center,
              color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Take Skin Quiz',
              onPressed: () => Navigator.pushNamed(context, '/quiz'),
              width: double.infinity,
              size: ButtonSize.large,
              icon: const Icon(Icons.arrow_forward, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized cart icon that only rebuilds when cart count changes
class CartIconWidget extends ConsumerWidget {
  final bool isDark;

  const CartIconWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider.select((count) => count));
    
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
        ),
        if (itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$itemCount',
                style: const TextStyle(
                  color: Colors.white,
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

// Skin overview section
class SkinOverviewSection extends ConsumerWidget {
  final bool isDark;

  const SkinOverviewSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(skinProfileProvider.select((p) => p));
    final overview = ref.watch(skinOverviewProvider(profile));

    if (profile == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBrown.withOpacity(0.1),
            AppColors.primaryBrown.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBrown.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DisplayText(
                          'Your Skin Overview',
                          color: AppColors.primaryBrown,
                          isLarge: false,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'IMPORTANT',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CaptionText(
                      'Your personalized skin analysis and recommendations',
                      color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Skin Type Display
          TitleText(
            'Your Skin Type: ${profile.skinType}',
            color: AppColors.primaryBrown,
          ),
          
          // Concerns
          if (profile.concerns.isNotEmpty) ...[
            const SizedBox(height: 12),
            const TitleText(
              'Concerns:',
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: profile.concerns.map((concern) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: CaptionText(
                    concern,
                    color: Colors.orange.shade700,
                  ),
                ),
              ).toList(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Overview text
          BodyText(
            overview,
            color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
            height: 1.6,
          ),
        ],
      ),
    );
  }
}

// Skin routine section with optimized rebuilds
class SkinRoutineSection extends ConsumerWidget {
  final bool isDark;

  const SkinRoutineSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(
          'Your Personalized Routine',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 16),
        
        // Morning and Evening Routine Tabs
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: AppColors.primaryBrown,
                unselectedLabelColor: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
                indicatorColor: AppColors.primaryBrown,
                indicatorWeight: 3,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.wb_sunny, size: 20),
                    text: 'Morning',
                  ),
                  Tab(
                    icon: Icon(Icons.nightlight_round, size: 20),
                    text: 'Evening',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 400,
                ),
                child: TabBarView(
                  children: [
                    RoutineProductsList(isDark: isDark, routine: 'Morning'),
                    RoutineProductsList(isDark: isDark, routine: 'Evening'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Routine products list that rebuilds only when routine products change
class RoutineProductsList extends ConsumerWidget {
  final bool isDark;
  final String routine;

  const RoutineProductsList({
    super.key,
    required this.isDark,
    required this.routine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(skinProfileProvider.select((p) => p));
    
    if (profile == null) {
      return const Center(child: Text('Profile not available'));
    }

    final provider = routine == 'Morning' 
        ? morningRoutineProvider(profile) 
        : eveningRoutineProvider(profile);
    
    final routineState = ref.watch(provider);

    if (routineState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (routineState.error != null) {
      return Center(
        child: Text('Error: ${routineState.error}'),
      );
    }

    final products = routineState.products;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              routine == 'Morning' ? Icons.wb_sunny : Icons.nightlight_round,
              size: 48,
              color: isDark ? AppColors.creamBackground.withOpacity(0.3) : AppColors.lightText,
            ),
            const SizedBox(height: 16),
            CaptionText(
              'No $routine routine products found for your skin type.',
              color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (products.length <= 3) {
      return Column(
        children: products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return RoutineProductItem(
            product: product, 
            isDark: isDark, 
            step: index + 1,
          );
        }).toList(),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return RoutineProductItem(
          product: product, 
          isDark: isDark, 
          step: index + 1,
        );
      },
    );
  }
}

// Individual routine product item
class RoutineProductItem extends ConsumerWidget {
  final Map<String, dynamic> product;
  final bool isDark;
  final int step;

  const RoutineProductItem({
    super.key,
    required this.product,
    required this.isDark,
    required this.step,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: product['id'].toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBrown.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Step number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['stepName'] ?? 'Step',
                    style: const TextStyle(
                      color: AppColors.primaryBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product['name'] ?? '',
                    style: TextStyle(
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, child) {
                      final currency = ref.watch(currencyProvider);
                      final price = (product['price'] as num?)?.toDouble() ?? 0.0;
                      final convertedPrice = CurrencyUtils.convertPrice(price, currency);
                      return CaptionText(
                        CurrencyUtils.formatPrice(convertedPrice, currency),
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w600,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Add to cart button
            IconButton(
              onPressed: () => _addToCart(ref, context, product),
              icon: const Icon(
                Icons.add_shopping_cart,
                color: AppColors.primaryBrown,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(WidgetRef ref, BuildContext context, Map<String, dynamic> product) {
    ref.read(cartProvider.notifier).addItem({
      'id': product['id'].toString(),
      'name': product['name'],
      'brand': 'K-Beauty Pro',
      'image': product['images'] ?? '',
      'price': product['price'],
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// Recommended treatments section
class RecommendedTreatmentsSection extends ConsumerWidget {
  final bool isDark;

  const RecommendedTreatmentsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(skinProfileProvider.select((p) => p));
    final treatmentsAsync = ref.watch(recommendedTreatmentsProvider(profile));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(
          'Recommended Treatments',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 16),
        
        treatmentsAsync.when(
          data: (treatments) {
            if (treatments.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CaptionText(
                  'No treatments found for your skin type.',
                  color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
                ),
              );
            }
            
            final firstTreatment = treatments.first;
            return TreatmentCard(treatment: firstTreatment, isDark: isDark);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading treatments: $error'),
          ),
        ),
      ],
    );
  }
}

// Treatment card widget
class TreatmentCard extends StatelessWidget {
  final Map<String, dynamic> treatment;
  final bool isDark;

  const TreatmentCard({
    super.key, 
    required this.treatment, 
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Treatment details for: ${treatment['name']}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 180,
          maxHeight: 220,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBrown.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.spa,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final currency = ref.watch(currencyProvider);
                      final price = (treatment['price'] as num?)?.toDouble() ?? 0.0;
                      final convertedPrice = CurrencyUtils.convertPrice(price, currency);
                      return CaptionText(
                        CurrencyUtils.formatPrice(convertedPrice, currency),
                        color: AppColors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TitleText(
              treatment['name'] ?? '',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                treatment['whatItIs'] ?? '',
                style: TextStyle(
                  color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CaptionText(
                    treatment['duration'] ?? '',
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _navigateToBooking(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBooking(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
        settings: const RouteSettings(arguments: {'initialTab': 2}),
      ),
      (route) => false,
    );
  }
}