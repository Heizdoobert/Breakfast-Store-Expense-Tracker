import 'package:extractorapplication/views/owner/dashboard/widgets/recent_activity.dart';
import 'package:extractorapplication/views/owner/dashboard/widgets/stats_card.dart';
import 'package:extractorapplication/views/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import '../../../Controller/owner/owner_dashboard_controller.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  final controller = OwnerDashboardController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.loadDashboardData().then((_) {
      if(mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
