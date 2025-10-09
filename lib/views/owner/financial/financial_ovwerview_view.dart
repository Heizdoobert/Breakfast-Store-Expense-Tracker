import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/financial_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../../shared/loading_indicator.dart';

//Cần StatefulWidget để quản lý TabController
//khoi tao tabcontroller voi 2 tab
//goi controller tu provider
//tao ham tai du lieu chi de load 1 lan
class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static final DateFormatter _formatDate = DateFormatter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FinancialController>();

    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadFinancialData();
      });
    }

    if (controller.isLoading && controller.monthlyReport.isEmpty) {
      return const LoadingIndicator(fullscreen: true, message: 'Đang tải dữ liệu tài chính...');
    }

    return Scaffold(
      appBar: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tổng quan'),
            Tab(text: 'Báo cáo chi tiết'),
          ],
        ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, controller),
          _buildDetailedReportTab(controller),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, FinancialController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadFinancialData,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tổng doanh thu: ${controller.totalRevenue.toStringAsFixed(0)} VNĐ',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedReportTab(FinancialController controller) {
    if (controller.monthlyReport.isEmpty) {
      return const Center(child: Text('Không có dữ liệu chi tiêu để hiển thị.'));
    }

    return RefreshIndicator(
      onRefresh: controller.loadFinancialData,
      child: ListView.builder(
        itemCount: controller.monthlyReport.length,
        itemBuilder: (context, i) {
          final expense = controller.monthlyReport[i];
          return ListTile(
            title: Text('🧾 ${expense.description ?? 'Không có mô tả'}'),
            subtitle: Text(
              '👤 Người dùng: ${expense.userId ?? 'Không rõ'}\n📅 Ngày: ${_formatDate.formatDateTime(expense.createdAt)}',
            ),
            trailing: Text('${expense.amount?.toStringAsFixed(0) ?? '0'} VNĐ'),
          );
        },
      ),
    );
  }
}