import 'package:json_annotation/json_annotation.dart';

part 'budget_models.g.dart';

@JsonSerializable()
class BudgetProfile {
  final double monthlyBudget;
  final double currentMonthSpent;
  final String currency;
  final DateTime budgetSetDate;
  final List<ExpenseTransaction> transactions;

  const BudgetProfile({
    required this.monthlyBudget,
    this.currentMonthSpent = 0.0,
    this.currency = 'USD',
    required this.budgetSetDate,
    this.transactions = const [],
  });

  factory BudgetProfile.fromJson(Map<String, dynamic> json) => _$BudgetProfileFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetProfileToJson(this);

  double get remainingBudget => monthlyBudget - currentMonthSpent;
  double get budgetUsedPercentage => (currentMonthSpent / monthlyBudget * 100).clamp(0, 100);
  bool get isOverBudget => currentMonthSpent > monthlyBudget;
  
  BudgetProfile copyWith({
    double? monthlyBudget,
    double? currentMonthSpent,
    String? currency,
    DateTime? budgetSetDate,
    List<ExpenseTransaction>? transactions,
  }) {
    return BudgetProfile(
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      currentMonthSpent: currentMonthSpent ?? this.currentMonthSpent,
      currency: currency ?? this.currency,
      budgetSetDate: budgetSetDate ?? this.budgetSetDate,
      transactions: transactions ?? this.transactions,
    );
  }
}

@JsonSerializable()
class ExpenseTransaction {
  final String id;
  final String productName;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String? notes;

  const ExpenseTransaction({
    required this.id,
    required this.productName,
    required this.amount,
    required this.date,
    required this.category,
    this.notes,
  });

  factory ExpenseTransaction.fromJson(Map<String, dynamic> json) => _$ExpenseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseTransactionToJson(this);
}

@JsonSerializable()
class WellnessData {
  final DateTime date;
  final double sleepHours;
  final double waterIntakeLiters;
  final int skinRating; // 1-5 scale for daily skin rating

  const WellnessData({
    required this.date,
    this.sleepHours = 0.0,
    this.waterIntakeLiters = 0.0,
    this.skinRating = 3,
  });

  factory WellnessData.fromJson(Map<String, dynamic> json) => _$WellnessDataFromJson(json);
  Map<String, dynamic> toJson() => _$WellnessDataToJson(this);

  WellnessData copyWith({
    DateTime? date,
    double? sleepHours,
    double? waterIntakeLiters,
    int? skinRating,
  }) {
    return WellnessData(
      date: date ?? this.date,
      sleepHours: sleepHours ?? this.sleepHours,
      waterIntakeLiters: waterIntakeLiters ?? this.waterIntakeLiters,
      skinRating: skinRating ?? this.skinRating,
    );
  }
}

enum ExpenseCategory {
  cleanser,
  moisturizer,
  serum,
  sunscreen,
  treatment,
  tools,
  makeup,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.cleanser:
        return 'Cleanser';
      case ExpenseCategory.moisturizer:
        return 'Moisturizer';
      case ExpenseCategory.serum:
        return 'Serum';
      case ExpenseCategory.sunscreen:
        return 'Sunscreen';
      case ExpenseCategory.treatment:
        return 'Treatment';
      case ExpenseCategory.tools:
        return 'Tools';
      case ExpenseCategory.makeup:
        return 'Makeup';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}