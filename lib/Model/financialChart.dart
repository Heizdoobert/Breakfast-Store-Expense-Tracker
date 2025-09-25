// lib/models/finance_model.dart
class FinanceModel {
  final double availableBalance;
  final double totalBudget;
  final double spentAmount;
  final List<double> trendValues;
  final List<String> trendLabels;
  final double netWorthChangePercent;

  FinanceModel({
    required this.availableBalance,
    required this.totalBudget,
    required this.spentAmount,
    required this.trendValues,
    required this.trendLabels,
    required this.netWorthChangePercent,
  });

  double get remainingBudget => totalBudget - spentAmount;
  double get netWorth => availableBalance + remainingBudget;
}