import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/financial_controller.dart';
import '../../../core/utils/date_formatter.dart';

// provider da lang nghe view nen chuyen ve chi load view
class FinancialOverviewView extends StatelessWidget {
  const FinancialOverviewView({super.key});
  static final DateFormatter _formatDate = DateFormatter();

  @override
  Widget build(BuildContext context) {
    //Lấy controller từ Provider. `watch` sẽ lắng nghe sự thay đổi
    final controller = context.watch<FinancialController>();

    // Gọi hàm load dữ liệu nếu cần (chỉ gọi 1 lần)
    // Cách làm này đảm bảo dữ liệu chỉ được load khi cần thiết.
    if (controller.shouldLoadData) {
      print(controller);
      controller.loadFinancialData();
    }

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '💰 Tổng doanh thu: ${controller.totalRevenue.toStringAsFixed(0)} VNĐ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: controller.monthlyReport.isEmpty
                ? const Center(child: Text('Không có dữ liệu chi tiêu'))
                : ListView.builder(
                    itemCount: controller.monthlyReport.length,
                    itemBuilder: (_, i) {
                      final expense = controller.monthlyReport[i];
                      return ListTile(
                        title: Text(
                            '📝 ${expense.description ?? 'Không có mô tả'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '👤 Người dùng: ${expense.userId ?? 'Không rõ'}'),
                            Text(
                                '👥 Nhóm: ${expense.groupId ?? 'Không có nhóm'}'),
                            Text(
                                '📅 Ngày: ${_formatDate.formatDateTime(expense.createdAt)}'),
                          ],
                        ),
                        trailing: Text(
                            '${expense.amount?.toStringAsFixed(0) ?? '0'} VNĐ'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
