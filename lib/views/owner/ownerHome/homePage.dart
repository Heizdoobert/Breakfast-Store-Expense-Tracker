// lib/views/owner/ownerHome/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../Controller/financialController.dart';
import 'widget/homePageWidget.dart';

class HomePage extends StatelessWidget {
  final controller = FinanceController();

  Future<int?> getUserIdFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: getUserIdFromSession(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Center(child: Text('Lỗi khi lấy userId: ${userSnapshot.error}'));
        }
        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return const Center(child: Text('Không tìm thấy userId trong session'));
        }

        final userId = userSnapshot.data!;

        return FutureBuilder(
          future: controller.fetchFinanceData(userId),
          builder: (context, financeSnapshot) {
            if (financeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (financeSnapshot.hasError) {
              return Center(child: Text('Lỗi khi tải dữ liệu tài chính: ${financeSnapshot.error}'));
            }
            if (!financeSnapshot.hasData || financeSnapshot.data == null) {
              return const Center(child: Text('Không có dữ liệu tài chính'));
            }

            final model = financeSnapshot.data!;
            final spots = List.generate(
              model.trendValues.length,
                  (i) => FlSpot(i.toDouble(), model.trendValues[i] / 1000),
            );
            final daysLeft = DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                .difference(DateTime.now())
                .inDays;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FinancialOverviewCard(
                    availableBalance: model.availableBalance,
                    daysLeft: daysLeft,
                    totalBudget: model.totalBudget,
                    spentAmount: model.spentAmount,
                    netWorthTrend: spots,
                    xLabels: model.trendLabels,
                    periodLabel: 'Month',
                    netWorthChangePercent: model.netWorthChangePercent,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}