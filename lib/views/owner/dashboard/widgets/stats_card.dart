import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int totalUsers;
  final double totalRevenue;
  final String systemHealth;


  const StatsCard({
    super.key,
    required this.totalUsers,
    required this.totalRevenue,
    required this.systemHealth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👥 Người dùng: $totalUsers'),
            Text('💰 Doanh thu: \$${totalRevenue.toStringAsFixed(2)}'),
            Text('🛠️ Hệ thống: $systemHealth'),
          ],
        ),
      ),
    );
  }
}