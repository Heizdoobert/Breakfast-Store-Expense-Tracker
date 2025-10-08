import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/financial_controller.dart';
import '../../../core/utils/date_formatter.dart';

// View này chỉ cần là StatelessWidget
class RevenueReportView extends StatelessWidget {
  const RevenueReportView({super.key});
  static final DateFormatter _formatDate = DateFormatter();

  @override
  Widget build(BuildContext context) {
    // 1. Lấy và lắng nghe RevenueReportController
    final controller = context.watch<RevenueReportController>();

    // 2. Gọi hàm tải dữ liệu nếu cần
    if (controller.shouldLoadData) {
      // Gọi hàm đúng của controller này
      controller.loadRevenueReport();
    }

    // 3. Xây dựng UI dựa trên trạng thái của RevenueReportController
    return Scaffold(
      appBar: AppBar(title: const Text('📈 Báo cáo doanh thu theo tháng')),
      body: _buildBody(controller), // Tách UI ra một hàm riêng cho sạch sẽ
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
          title: Text('🧾 ${expense.description ?? 'Không có mô tả'}'),
          subtitle: Text(
            '👤 Người dùng: ${expense.userId ?? 'Không rõ'}\n📅 Ngày: ${_formatDate.formatDateTime(expense.createdAt)}',
          ),
          trailing: Text('${expense.amount?.toStringAsFixed(0) ?? '0'} VNĐ'),
        );
      },
    );
  }
}