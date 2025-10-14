import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/skin_profile_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/currency_provider.dart';
import '../../services/product_service.dart';
import '../../widgets/common/circular_progress_chart.dart';
import '../../widgets/common/skin_stat_bar.dart';
import '../../widgets/common/budget_dialogs.dart';
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
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
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
            
            const SizedBox(height: 16),
            
            // Featured skin overview section at the top
            Container(
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: AppColors.primaryBrown,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DisplayText(
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
                  BodyText(
                    _generateSkinOverview(profile!),
                    color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
                    height: 1.6,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to detailed skin analysis or recommendations
                      },
                      icon: const Icon(Icons.insights, size: 16),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
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
                    color: AppColors.primaryBrown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.primaryBrown,
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
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            CaptionText(
                              'Score your skin',
                              color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                            ),
                            const SizedBox(height: 8),
                            DisplayText(
                              '$skinScore%',
                              color: AppColors.primaryBrown,
                              isLarge: true,
                            ),
                          ],
                        ),
                        // Performance indicator
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: skinScore >= 80 
                                  ? Colors.green 
                                  : skinScore >= 60 
                                      ? Colors.orange 
                                      : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomCard(
                    type: CardType.filled,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            CaptionText(
                              'Score skin age',
                              color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                            ),
                            const SizedBox(height: 8),
                            DisplayText(
                              '$skinAge',
                              color: AppColors.primaryBrown,
                              isLarge: true,
                            ),
                          ],
                        ),
                        // Age indicator
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: skinAge <= 25 
                                  ? Colors.green.withOpacity(0.2)
                                  : skinAge <= 35 
                                      ? Colors.orange.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skinAge <= 25 
                                  ? 'Young'
                                  : skinAge <= 35 
                                      ? 'Mature'
                                      : 'Aging',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: skinAge <= 25 
                                    ? Colors.green
                                    : skinAge <= 35 
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                          ),
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
                        color: AppColors.primaryBrown,
                      ),
                      SkinStatBar(
                        label: 'Skin wrinkles',
                        value: stats['wrinkles'] ?? 0.0,
                        color: AppColors.primaryBrown.withOpacity(0.8),
                      ),
                      SkinStatBar(
                        label: 'Sensitive skin',
                        value: stats['sensitivity'] ?? 0.0,
                        color: AppColors.primaryBrown.withOpacity(0.6),
                      ),
                      SkinStatBar(
                        label: 'Skin moisture',
                        value: stats['moisture'] ?? 0.0,
                        color: AppColors.primaryBrown.withOpacity(0.4),
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
            
            // Budget and Wellness Tracking Section
            _buildBudgetAndWellnessSection(context, ref, isDark),
            
            const SizedBox(height: 32),
            
            // Add bottom padding for the island tab bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBudgetAndWellnessSection(BuildContext context, WidgetRef ref, bool isDark) {
    final budgetProfile = ref.watch(budgetProfileProvider);
    final todayWellness = ref.watch(todayWellnessProvider);
    final hasBudget = ref.watch(hasBudgetSetupProvider);
    final budgetWarning = ref.watch(budgetWarningProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Budget Card
        if (!hasBudget)
          _buildBudgetSetupCard(context, ref, isDark)
        else
          _buildBudgetTrackingCard(context, ref, budgetProfile!, budgetWarning, isDark),
        
        const SizedBox(height: 20),
        
        // Wellness Tracking
        HeadingText(
          'Daily Wellness Tracker',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Sleep Tracking
            Expanded(
              child: _buildWellnessCard(
                context: context,
                ref: ref,
                isDark: isDark,
                title: 'Sleep',
                icon: Icons.bedtime,
                value: todayWellness.sleepHours,
                unit: 'hrs',
                target: 8.0,
                onTap: () => _showSleepInput(context, ref, todayWellness.sleepHours),
              ),
            ),
            const SizedBox(width: 16),
            // Water Tracking
            Expanded(
              child: _buildWellnessCard(
                context: context,
                ref: ref,
                isDark: isDark,
                title: 'Water',
                icon: Icons.water_drop,
                value: todayWellness.waterIntakeLiters,
                unit: 'L',
                target: 2.5,
                onTap: () => _showWaterInput(context, ref, todayWellness.waterIntakeLiters),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildBudgetSetupCard(BuildContext context, WidgetRef ref, bool isDark) {
    return CustomCard(
      type: CardType.elevated,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primaryBrown,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        'Set Your Monthly Budget',
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                      CaptionText(
                        'Track your skincare spending',
                        color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BodyText(
              'Set a monthly budget to track your skincare expenses and get insights on your spending habits.',
              color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
              height: 1.4,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Set Budget',
              onPressed: () => _showBudgetSetupDialog(context, ref),
              width: double.infinity,
              size: ButtonSize.medium,
              icon: const Icon(Icons.add, color: AppColors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBudgetTrackingCard(BuildContext context, WidgetRef ref, budget, budgetWarning, bool isDark) {
    final now = DateTime.now();
    final currency = ref.watch(currencyProvider);
    
    // Convert budget amounts to selected currency for display
    final convertedMonthlyBudget = CurrencyUtils.convertPrice(budget.monthlyBudget, currency);
    final convertedCurrentSpent = CurrencyUtils.convertPrice(budget.currentMonthSpent, currency);
    final convertedRemainingBudget = CurrencyUtils.convertPrice(budget.remainingBudget, currency);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Month Navigation Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to previous month
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                    size: 28,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _getMonthName(now.month),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                    ),
                    Text(
                      now.year.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to next month
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                    size: 28,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Amount Left - Large Display
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: CurrencyUtils.formatPrice(convertedRemainingBudget, currency),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: budget.isOverBudget ? Colors.red : AppColors.darkText,
                      height: 1.0,
                    ),
                  ),
                  TextSpan(
                    text: ' left',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Spent vs Budgeted
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyUtils.formatPrice(convertedCurrentSpent, currency)} spent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.darkText,
                  ),
                ),
                Text(
                  '${CurrencyUtils.formatPrice(convertedMonthlyBudget, currency)} budgeted',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isDark ? AppColors.darkBackground : AppColors.lightText.withOpacity(0.2),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isDark ? AppColors.darkBackground : AppColors.lightText.withOpacity(0.2),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: (budget.budgetUsedPercentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: budget.isOverBudget 
                          ? Colors.red 
                          : budget.budgetUsedPercentage >= 80 
                            ? Colors.orange 
                            : AppColors.primaryBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _showBudgetSetupDialog(context, ref),
                icon: const Icon(Icons.edit, size: 18, color: AppColors.white),
                label: const Text(
                  'Edit Budget',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWellnessCard({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required String title,
    required IconData icon,
    required double value,
    required String unit,
    required double target,
    required VoidCallback onTap,
  }) {
    final progress = (value / target).clamp(0.0, 1.0);
    final isTargetMet = value >= target;
    
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        type: CardType.filled,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: isTargetMet ? Colors.green : AppColors.primaryBrown,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CaptionText(
                      title,
                      color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              TitleText(
                '${value.toStringAsFixed(1)}$unit',
                color: isTargetMet ? Colors.green : AppColors.primaryBrown,
              ),
              
              const SizedBox(height: 8),
              
              LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryBrown.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isTargetMet ? Colors.green : AppColors.primaryBrown,
                ),
                minHeight: 4,
              ),
              
              const SizedBox(height: 4),
              
              CaptionText(
                'Goal: ${target.toStringAsFixed(1)}$unit',
                color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showBudgetSetupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => BudgetSetupDialog(),
    );
  }
  
  void _showSleepInput(BuildContext context, WidgetRef ref, double currentValue) {
    showDialog(
      context: context,
      builder: (context) => WellnessInputDialog(
        title: 'Sleep Hours',
        currentValue: currentValue,
        unit: 'hours',
        maxValue: 12.0,
        onSave: (value) {
          ref.read(todayWellnessProvider.notifier).updateSleepHours(value);
        },
      ),
    );
  }
  
  void _showWaterInput(BuildContext context, WidgetRef ref, double currentValue) {
    showDialog(
      context: context,
      builder: (context) => WellnessInputDialog(
        title: 'Water Intake',
        currentValue: currentValue,
        unit: 'liters',
        maxValue: 5.0,
        onSave: (value) {
          ref.read(todayWellnessProvider.notifier).updateWaterIntake(value);
        },
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
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