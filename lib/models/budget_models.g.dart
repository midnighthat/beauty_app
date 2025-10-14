// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetProfile _$BudgetProfileFromJson(Map<String, dynamic> json) =>
    BudgetProfile(
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      currentMonthSpent: (json['currentMonthSpent'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      budgetSetDate: DateTime.parse(json['budgetSetDate'] as String),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map(
                  (e) => ExpenseTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BudgetProfileToJson(BudgetProfile instance) =>
    <String, dynamic>{
      'monthlyBudget': instance.monthlyBudget,
      'currentMonthSpent': instance.currentMonthSpent,
      'currency': instance.currency,
      'budgetSetDate': instance.budgetSetDate.toIso8601String(),
      'transactions': instance.transactions,
    };

ExpenseTransaction _$ExpenseTransactionFromJson(Map<String, dynamic> json) =>
    ExpenseTransaction(
      id: json['id'] as String,
      productName: json['productName'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ExpenseTransactionToJson(ExpenseTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'notes': instance.notes,
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.cleanser: 'cleanser',
  ExpenseCategory.moisturizer: 'moisturizer',
  ExpenseCategory.serum: 'serum',
  ExpenseCategory.sunscreen: 'sunscreen',
  ExpenseCategory.treatment: 'treatment',
  ExpenseCategory.tools: 'tools',
  ExpenseCategory.makeup: 'makeup',
  ExpenseCategory.other: 'other',
};

WellnessData _$WellnessDataFromJson(Map<String, dynamic> json) => WellnessData(
      date: DateTime.parse(json['date'] as String),
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0.0,
      waterIntakeLiters: (json['waterIntakeLiters'] as num?)?.toDouble() ?? 0.0,
      skinRating: (json['skinRating'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$WellnessDataToJson(WellnessData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'sleepHours': instance.sleepHours,
      'waterIntakeLiters': instance.waterIntakeLiters,
      'skinRating': instance.skinRating,
    };
