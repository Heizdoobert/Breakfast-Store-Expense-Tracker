// lib/views/owner/dashboard/owner_dashboard_view.dart

import 'package:extractorapplication/views/owner/dashboard/widgets/recent_activity.dart';
import 'package:extractorapplication/views/owner/dashboard/widgets/stats_card.dart';
import 'package:extractorapplication/views/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/owner_dashboard_controller.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final controller = context.read<OwnerDashboardController>();
      if (controller.shouldLoadData) {
        controller.loadDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((OwnerDashboardController c) => c.isLoading);
    final hasData = context.select((OwnerDashboardController c) => c.recentNotes.isNotEmpty);

    return Scaffold(
      body: (isLoading && !hasData)
          ? const LoadingIndicator(
              fullscreen: true, 
              message: 'Đang tải dữ liệu...'
            )
          : RefreshIndicator(
              onRefresh: () => context.read<OwnerDashboardController>().loadDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Consumer<OwnerDashboardController>(
                      builder: (context, controller, child) {
                        return Column(
                          children: [
                            StatsCard(
                              totalUsers: controller.totalUsers,
                              totalRevenue: controller.totalRevenue,
                              systemHealth: controller.systemHealth,
                            ),
                            const SizedBox(height: 20),
                            RecentNotesView(notes: controller.recentNotes),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
