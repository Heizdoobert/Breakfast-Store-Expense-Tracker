import 'package:extractorapplication/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/financial_controller.dart';

class RevenueReportView extends StatelessWidget {
  final formatDate = DateFormatter();
   RevenueReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RevenueReportController()..loadRevenueReport(),
      child: Consumer<RevenueReportController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(title: const Text('📈 Báo cáo doanh thu theo tháng')),
            body: ListView.builder(
              itemCount: controller.monthlyRevenue.length,
              itemBuilder: (_, i) {
                final expense = controller.monthlyRevenue[i];
                return ListTile(
                  title: Text('🧾 ${expense.description ?? 'Không có mô tả'}'),
                  subtitle: Text(
                    '👤 Người dùng: ${expense.userId ?? 'Không rõ'}\n📅 Ngày: ${formatDate.formatDateTime(expense.createdAt)}',
                  ),
                  trailing: Text('${expense.amount?.toStringAsFixed(0) ?? '0'} VNĐ'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}