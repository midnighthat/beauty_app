import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_models.dart';
import '../services/preferences_service.dart';

// Budget profile provider
final budgetProfileProvider = StateNotifierProvider<BudgetProfileNotifier, BudgetProfile?>((ref) {
  return BudgetProfileNotifier();
});

// Today's wellness data provider
final todayWellnessProvider = StateNotifierProvider<WellnessDataNotifier, WellnessData>((ref) {
  return WellnessDataNotifier();
});

// Budget setup status provider
final hasBudgetSetupProvider = Provider<bool>((ref) {
  final budget = ref.watch(budgetProfileProvider);
  return budget != null;
});

// Budget warning provider
final budgetWarningProvider = Provider<BudgetWarning?>((ref) {
  final budget = ref.watch(budgetProfileProvider);
  if (budget == null) return null;

  if (budget.isOverBudget) {
    return BudgetWarning.exceeded;
  } else if (budget.budgetUsedPercentage >= 80) {
    return BudgetWarning.nearLimit;
  }
  return null;
});

class BudgetProfileNotifier extends StateNotifier<BudgetProfile?> {
  BudgetProfileNotifier() : super(null) {
    _loadBudgetProfile();
  }

  Future<void> _loadBudgetProfile() async {
    try {
      final savedBudget = await PreferencesService.getBudgetProfile();
      state = savedBudget;
    } catch (e) {
      print('Error loading budget profile: $e');
    }
  }

  Future<void> setBudget(double monthlyAmount, String currency) async {
    final newBudget = BudgetProfile(
      monthlyBudget: monthlyAmount,
      currency: currency,
      budgetSetDate: DateTime.now(),
    );
    
    state = newBudget;
    await PreferencesService.saveBudgetProfile(newBudget);
  }

  Future<void> addExpense(ExpenseTransaction transaction) async {
    if (state == null) return;

    final updatedTransactions = [...state!.transactions, transaction];
    final newSpent = state!.currentMonthSpent + transaction.amount;

    final updatedBudget = state!.copyWith(
      currentMonthSpent: newSpent,
      transactions: updatedTransactions,
    );

    state = updatedBudget;
    await PreferencesService.saveBudgetProfile(updatedBudget);
  }

  Future<void> resetMonthlySpending() async {
    if (state == null) return;

    final resetBudget = state!.copyWith(
      currentMonthSpent: 0.0,
      transactions: [],
    );

    state = resetBudget;
    await PreferencesService.saveBudgetProfile(resetBudget);
  }
}

class WellnessDataNotifier extends StateNotifier<WellnessData> {
  WellnessDataNotifier() : super(WellnessData(date: DateTime.now())) {
    _loadTodayWellness();
  }

  Future<void> _loadTodayWellness() async {
    try {
      final today = DateTime.now();
      final savedWellness = await PreferencesService.getWellnessData(today);
      if (savedWellness != null) {
        state = savedWellness;
      }
    } catch (e) {
      print('Error loading wellness data: $e');
    }
  }

  Future<void> updateSleepHours(double hours) async {
    final updated = state.copyWith(sleepHours: hours);
    state = updated;
    await PreferencesService.saveWellnessData(updated);
  }

  Future<void> updateWaterIntake(double liters) async {
    final updated = state.copyWith(waterIntakeLiters: liters);
    state = updated;
    await PreferencesService.saveWellnessData(updated);
  }

  Future<void> updateSkinRating(int rating) async {
    final updated = state.copyWith(skinRating: rating);
    state = updated;
    await PreferencesService.saveWellnessData(updated);
  }
}

enum BudgetWarning {
  nearLimit,
  exceeded,
}

extension BudgetWarningExtension on BudgetWarning {
  String get message {
    switch (this) {
      case BudgetWarning.nearLimit:
        return 'You\'ve used 80% of your monthly budget';
      case BudgetWarning.exceeded:
        return 'Budget exceeded! Consider reviewing your spending';
    }
  }

  String get actionText {
    switch (this) {
      case BudgetWarning.nearLimit:
        return 'Review Budget';
      case BudgetWarning.exceeded:
        return 'View Details';
    }
  }
}