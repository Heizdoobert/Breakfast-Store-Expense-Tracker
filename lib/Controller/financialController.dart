// lib/controllers/finance_controller.dart
import 'package:extractorapplication/services/db_help.dart';
import '../Model/financialChart.dart';

class FinanceController {
  final service = DatabaseHelper();

  Future<FinanceModel> fetchFinanceData(int userId) async {
    final available = await service.getAvailableBalance(userId);
    final budget = await service.getTotalBudget(userId);
    final spent = await service.getSpentAmount(userId);
    final trendSpots = await service.getNetWorthTrend(userId);
    final trendLabels = await service.getDateLabels(userId);
    final changePercent = await service.getNetWorthChangePercent(userId);

    return FinanceModel(
      availableBalance: available,
      totalBudget: budget,
      spentAmount: spent,
      trendValues: trendSpots.map((e) => e.y).toList(),
      trendLabels: trendLabels,
      netWorthChangePercent: changePercent,
    );
  }
}