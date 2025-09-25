import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../services/db_help.dart';

class FinancialOverviewCard extends StatelessWidget {
  final double availableBalance;
  final int daysLeft;
  final double totalBudget;
  final double spentAmount;
  final List<FlSpot> netWorthTrend;
  final List<String> xLabels;
  final String periodLabel;
  final double netWorthChangePercent;

  const FinancialOverviewCard({
    super.key,
    required this.availableBalance,
    required this.daysLeft,
    required this.totalBudget,
    required this.spentAmount,
    required this.netWorthTrend,
    required this.xLabels,
    required this.periodLabel,
    required this.netWorthChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    final remainingBudget = totalBudget - spentAmount;
    final dailyBudget = daysLeft > 0 ? remainingBudget / daysLeft : 0;
    final isDecrease = netWorthChangePercent < 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Available Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Balance', style: TextStyle(fontSize: 16)),
                TextButton(onPressed: () {}, child: const Text('Details >')),
              ],
            ),
            Text(
              '\$${availableBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// Budget Info
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$daysLeft more days - \$${dailyBudget.toStringAsFixed(2)} per day. Left',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${remainingBudget.toStringAsFixed(2)} of \$${totalBudget.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.info_outline, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Net Worth Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Net Worth',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: periodLabel,
                  items: ['Month', 'Week', 'Year']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                  underline: const SizedBox(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '\$${(availableBalance + remainingBudget).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      isDecrease ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDecrease ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    Text(
                      '${netWorthChangePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isDecrease ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Line Chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return Text(
                              xLabels[index],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          if (value == 0) return const Text('0');
                          if (value == 2) return const Text('2k');
                          if (value == 3) return const Text('3k');
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: netWorthTrend,
                      isCurved: true,
                      color: Colors.blueAccent,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
