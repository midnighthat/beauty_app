import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/budget_provider.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/common/budget_dialogs.dart';
import '../../providers/home_providers.dart';

// Budget and wellness section
class BudgetAndWellnessSection extends ConsumerWidget {
  final bool isDark;

  const BudgetAndWellnessSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Budget Card
        const BudgetCard(),
        
        const SizedBox(height: 20),
        
        // Wellness Tracking
        WellnessTrackingSection(isDark: isDark),
      ],
    );
  }
}

// Budget card that rebuilds only when budget data changes
class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasBudget = ref.watch(hasBudgetSetupProvider.select((has) => has));

    return hasBudget 
        ? const BudgetTrackingCard()
        : BudgetSetupCard(isDark: isDark);
  }
}

// Budget setup card for new users
class BudgetSetupCard extends StatelessWidget {
  final bool isDark;

  const BudgetSetupCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(
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
            Consumer(
              builder: (context, ref, child) {
                return PrimaryButton(
                  text: 'Set Budget',
                  onPressed: () => _showBudgetSetupDialog(context, ref),
                  width: double.infinity,
                  size: ButtonSize.medium,
                  icon: const Icon(Icons.add, color: AppColors.white, size: 18),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBudgetSetupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const BudgetSetupDialog(),
    );
  }
}

// Budget tracking card for existing budget users
class BudgetTrackingCard extends ConsumerWidget {
  const BudgetTrackingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final budget = ref.watch(budgetProfileProvider.select((b) => b));
    final currency = ref.watch(currencyProvider.select((c) => c));
    final monthName = ref.watch(monthNameProvider);

    if (budget == null) return const SizedBox.shrink();

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
            BudgetMonthHeader(monthName: monthName, isDark: isDark),
            
            const SizedBox(height: 32),
            
            // Amount Left - Large Display
            BudgetAmountDisplay(
              remainingBudget: convertedRemainingBudget,
              currency: currency,
              isOverBudget: budget.isOverBudget,
              isDark: isDark,
            ),
            
            const SizedBox(height: 24),
            
            // Spent vs Budgeted
            BudgetSpendingInfo(
              currentSpent: convertedCurrentSpent,
              monthlyBudget: convertedMonthlyBudget,
              currency: currency,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            BudgetProgressBar(
              budgetUsedPercentage: budget.budgetUsedPercentage,
              isOverBudget: budget.isOverBudget,
              isDark: isDark,
            ),
            
            const SizedBox(height: 32),
            
            // Action Button
            BudgetEditButton(),
          ],
        ),
      ),
    );
  }
}

// Budget month header
class BudgetMonthHeader extends StatelessWidget {
  final String monthName;
  final bool isDark;

  const BudgetMonthHeader({
    super.key,
    required this.monthName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    return Row(
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
              monthName,
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
    );
  }
}

// Budget amount display
class BudgetAmountDisplay extends StatelessWidget {
  final double remainingBudget;
  final String currency;
  final bool isOverBudget;
  final bool isDark;

  const BudgetAmountDisplay({
    super.key,
    required this.remainingBudget,
    required this.currency,
    required this.isOverBudget,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: CurrencyUtils.formatPrice(remainingBudget, currency),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: isOverBudget ? Colors.red : AppColors.darkText,
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
    );
  }
}

// Budget spending info
class BudgetSpendingInfo extends StatelessWidget {
  final double currentSpent;
  final double monthlyBudget;
  final String currency;
  final bool isDark;

  const BudgetSpendingInfo({
    super.key,
    required this.currentSpent,
    required this.monthlyBudget,
    required this.currency,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${CurrencyUtils.formatPrice(currentSpent, currency)} spent',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.darkText,
          ),
        ),
        Text(
          '${CurrencyUtils.formatPrice(monthlyBudget, currency)} budgeted',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

// Budget progress bar
class BudgetProgressBar extends StatelessWidget {
  final double budgetUsedPercentage;
  final bool isOverBudget;
  final bool isDark;

  const BudgetProgressBar({
    super.key,
    required this.budgetUsedPercentage,
    required this.isOverBudget,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            widthFactor: (budgetUsedPercentage / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isOverBudget 
                  ? Colors.red 
                  : budgetUsedPercentage >= 80 
                    ? Colors.orange 
                    : AppColors.primaryBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Budget edit button
class BudgetEditButton extends ConsumerWidget {
  const BudgetEditButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
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
    );
  }

  void _showBudgetSetupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const BudgetSetupDialog(),
    );
  }
}

// Wellness tracking section
class WellnessTrackingSection extends ConsumerWidget {
  final bool isDark;

  const WellnessTrackingSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWellness = ref.watch(todayWellnessProvider.select((w) => w));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(
          'Daily Wellness Tracker',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Sleep Tracking
            Expanded(
              child: WellnessCard(
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
              child: WellnessCard(
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
}

// Individual wellness card
class WellnessCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final double value;
  final String unit;
  final double target;
  final VoidCallback onTap;

  const WellnessCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    required this.target,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}