import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/financial_controller.dart';
import '../../../utils/date_formatter.dart';

class FinancialOverviewView extends StatefulWidget {
  const FinancialOverviewView({super.key});

  @override
  State<FinancialOverviewView> createState() => _FinancialOverviewViewState();
}

class _FinancialOverviewViewState extends State<FinancialOverviewView> {
  late FinancialController _controller;
  final formatDate = DateFormatter();

  @override
  void initState() {
    super.initState();
    _controller = FinancialController();
    _controller.loadFinancialData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<FinancialController>(
        builder: (context, controller, _) {
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
                        title: Text('📝 ${expense.description ?? 'Không có mô tả'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('👤 Người dùng: ${expense.userId ?? 'Không rõ'}'),
                            Text('👥 Nhóm: ${expense.groupId ?? 'Không có nhóm'}'),
                            Text('📅 Ngày: ${formatDate.formatDateTime(expense.createdAt)}'),
                          ],
                        ),
                        trailing: Text('${expense.amount?.toStringAsFixed(0) ?? '0'} VNĐ'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}