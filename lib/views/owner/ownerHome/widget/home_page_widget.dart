import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../../share/add_note_view.dart';

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
                const Text('Tổng số dư', style: TextStyle(fontSize: 16)),
                TextButton(onPressed: () {}, child: const Text('Chi tiết >')),
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
                          '$daysLeft ngày còn lại - \$${dailyBudget.toStringAsFixed(2)} mỗi ngày. Còn lại',
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
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Chi tiết ngân sách'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tổng ngân sách: \$${totalBudget.toStringAsFixed(2)}'),
                              Text('Đã chi tiêu: \$${spentAmount.toStringAsFixed(2)}'),
                              Text('Còn lại: \$${remainingBudget.toStringAsFixed(2)}'),
                              Text('Số ngày còn lại: $daysLeft'),
                              Text('Ngân sách mỗi ngày: \$${dailyBudget.toStringAsFixed(2)}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Đóng'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(Icons.info_outline, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Net Worth Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng tài sản',
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

//add button
class AddOptionsButton extends StatelessWidget {
  const AddOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.note_add, color: Colors.blueAccent),
                  title: const Text('Thêm ghi chú'),
                  onTap: () {
                    Navigator.pop(context); // đóng sheet hiện tại
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const AddNoteView(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: const Text('Thêm chi phí'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/add-expense'); // vẫn dùng route nếu đã đăng ký
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.orange),
                  title: const Text('Thêm staff mới'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/add-staff');
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
