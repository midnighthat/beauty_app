import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/skin_profile_provider.dart';
import '../../widgets/common/circular_progress_chart.dart';
import '../../widgets/common/skin_stat_bar.dart';
import '../cart/cart_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(skinProfileProvider);
    final hasProfile = ref.watch(hasCompletedQuizProvider);
    
    // If no profile, show quiz prompt
    if (!hasProfile) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: AppColors.primaryPink,
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

    final skinScore = ref.watch(skinScoreProvider);
    final skinAge = ref.watch(skinAgeProvider);
    final stats = ref.watch(skinStatisticsProvider);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with cart button
            Row(
              children: [
                const Spacer(),
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
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Skin test results header
            HeadingText(
              'Skin test results',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 8),
            BodyText(
              'Skin test reveals healthy complexion with AI-driven analysis',
              color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
            ),
            
            const SizedBox(height: 32),
            
            // Score section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.primaryPink,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      'Score your skin test',
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                    CaptionText(
                      'Today, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                      color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Score cards
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    type: CardType.filled,
                    child: Column(
                      children: [
                        CaptionText(
                          'Score your skin',
                          color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                        ),
                        const SizedBox(height: 8),
                        DisplayText(
                          '$skinScore%',
                          color: AppColors.primaryPink,
                          isLarge: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomCard(
                    type: CardType.filled,
                    child: Column(
                      children: [
                        CaptionText(
                          'Score skin age',
                          color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                        ),
                        const SizedBox(height: 8),
                        DisplayText(
                          '$skinAge',
                          color: AppColors.primaryPink,
                          isLarge: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Skin test statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingText(
                  'Skin test statistics',
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),
                Icon(
                  Icons.more_horiz,
                  color: isDark ? AppColors.creamBackground.withOpacity(0.5) : AppColors.lightText,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Statistics with chart
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SkinStatBar(
                        label: 'Elasticity skin',
                        value: stats['elasticity'] ?? 0.0,
                        color: AppColors.primaryPink,
                      ),
                      SkinStatBar(
                        label: 'Skin wrinkles',
                        value: stats['wrinkles'] ?? 0.0,
                        color: AppColors.primaryPink.withOpacity(0.8),
                      ),
                      SkinStatBar(
                        label: 'Sensitive skin',
                        value: stats['sensitivity'] ?? 0.0,
                        color: AppColors.primaryPink.withOpacity(0.6),
                      ),
                      SkinStatBar(
                        label: 'Skin moisture',
                        value: stats['moisture'] ?? 0.0,
                        color: AppColors.primaryPink.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: CircularProgressChart(
                    data: stats,
                    size: 120,
                    strokeWidth: 6,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Overview section
            HeadingText(
              'Overview of your skin',
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            const SizedBox(height: 16),
            BodyText(
              _generateSkinOverview(profile!),
              color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
              height: 1.6,
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Retake Quiz',
                    onPressed: () => Navigator.pushNamed(context, '/quiz'),
                    size: ButtonSize.medium,
                    icon: const Icon(Icons.refresh, color: AppColors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: 'Book Appointment',
                    onPressed: () {
                      // Switch to appointment tab (index 2)
                    },
                    size: ButtonSize.medium,
                    icon: const Icon(Icons.calendar_today, color: AppColors.primaryPink),
                  ),
                ),
              ],
            ),
            
            // Add bottom padding for the island tab bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  String _generateSkinOverview(profile) {
    final skinType = profile.skinType;
    final concerns = profile.concerns;
    
    String overview = 'Your skin analysis shows a $skinType skin type';
    
    if (concerns.isNotEmpty) {
      if (concerns.length == 1) {
        overview += ' with ${concerns.first} concerns.';
      } else {
        overview += ' with concerns including ${concerns.take(2).join(' and ')}';
        if (concerns.length > 2) overview += ' among others';
        overview += '.';
      }
    } else {
      overview += ' with healthy, balanced characteristics.';
    }
    
    overview += ' Following your personalized K-Beauty routine will help maintain and improve your skin\'s natural balance and radiance.';
    
    return overview;
  }
}