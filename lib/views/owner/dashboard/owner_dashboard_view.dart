import 'package:extractorapplication/views/owner/dashboard/widgets/recent_activity.dart';
import 'package:extractorapplication/views/owner/dashboard/widgets/stats_card.dart';
import 'package:extractorapplication/views/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/owner_dashboard_controller.dart';

///trang thai view load du lieu -> StateLessWidget
///lay controller tu provider de xem su thay doi
///chay widget 1 lan
/// dung addPostFrameCallback de tranh goi setState trong luc build
/// xay dung UI dua tren trang thai cua controller
class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OwnerDashboardController>();
    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadDashboardData();
      });
    }
    return Scaffold(
      body: controller.isLoading
          ? const LoadingIndicator(fullscreen: true, message: 'Loading...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  StatsCard(
                    totalUsers: controller.totalUsers,
                    totalRevenue: controller.totalRevenue,
                    systemHealth: controller.systemHealth,
                  ),
                  const SizedBox(height: 20),
                  RecentActivity(activities: controller.recentActivities),
                ],
              ),
            ),
    );
  }
}
