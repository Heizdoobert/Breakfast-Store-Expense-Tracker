// Path: lib/views/owner/dashboard/owner_dashboard_view.dart

// SỬA ĐỔI 1: Sửa import để khớp với tên file mới của widget hiển thị note.
// Giả định bạn đã đổi tên file`recent_activity.dart` thành `recent_notes_view.dart`.
import 'package:extractorapplication/views/owner/dashboard/widgets/recent_activity.dart';
import 'package:extractorapplication/views/owner/dashboard/widgets/stats_card.dart';
import 'package:extractorapplication/views/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/owner_dashboard_controller.dart';

/// Trang dashboard chính của Owner.
/// Chuyển thành StatefulWidget để quản lý việc tải dữ liệu ban đầu một cách tối ưu.
class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  @override
  void initState() {
    super.initState();
    // Gọi hàm tải dữ liệu một lần duy nhất khi widget được khởi tạo.
    final controller = context.read<OwnerDashboardController>();
    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          controller.loadDashboardData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OwnerDashboardController>();

    return Scaffold(
      body: (controller.isLoading && controller.recentNotes.isEmpty)
          ? const LoadingIndicator(
              fullscreen: true, message: 'Đang tải dữ liệu...')
          : RefreshIndicator(
              onRefresh: controller.loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    StatsCard(
                      totalUsers: controller.totalUsers,
                      totalRevenue: controller.totalRevenue,
                      systemHealth: controller.systemHealth,
                    ),
                    const SizedBox(height: 20),
                    RecentNotesView(notes: controller.recentNotes),
                  ],
                ),
              ),
            ),
    );
  }
}
