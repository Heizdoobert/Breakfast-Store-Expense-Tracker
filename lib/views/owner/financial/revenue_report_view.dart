import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/financial_controller.dart';
import '../../../core/utils/date_formatter.dart';

class RevenueReportView extends StatelessWidget {
  const RevenueReportView({super.key});
  static final DateFormatter _formatDate = DateFormatter();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RevenueReportController>();

    if (controller.shouldLoadData) {
      controller.loadRevenueReport();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('📈 Báo cáo doanh thu theo tháng')),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(RevenueReportController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.monthlyRevenue.isEmpty) {
      return const Center(child: Text('Không có dữ liệu để hiển thị.'));
    }

    return ListView.builder(
      itemCount: controller.monthlyRevenue.length,
      itemBuilder: (context, i) {
        final expense = controller.monthlyRevenue[i];
        return ListTile(
          title: Text('🧾 ${expense.description}'),
          subtitle: Text(
            '👤 Người dùng: ${expense.userId}\n📅 Ngày: ${_formatDate.formatDateTime(expense.createdAt)}',
          ),
          trailing: Text('${expense.amount.toStringAsFixed(0)} VNĐ'),
        );
      },
    );
  }
}
