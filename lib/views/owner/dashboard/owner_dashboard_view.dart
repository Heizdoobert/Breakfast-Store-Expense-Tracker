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
    // Sử dụng context.read() bên trong initState.
    final controller = context.read<OwnerDashboardController>();
    if (controller.shouldLoadData) {
      // Dùng addPostFrameCallback để đảm bảo việc gọi không xảy ra trong lúc build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          controller.loadDashboardData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dùng context.watch() trong hàm build để lắng nghe các thay đổi từ controller.
    final controller = context.watch<OwnerDashboardController>();

    return Scaffold(
      // SỬA ĐỔI 2: Cải thiện logic hiển thị trạng thái loading.
      // Chỉ hiển thị loading toàn màn hình khi chưa có dữ liệu gì.
      body: (controller.isLoading && controller.recentNotes.isEmpty)
          ? const LoadingIndicator(
              fullscreen: true, message: 'Đang tải dữ liệu...')
          : RefreshIndicator(
              onRefresh:
                  controller.loadDashboardData, // Cho phép kéo để làm mới
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Luôn cho phép cuộn để RefreshIndicator hoạt động
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    StatsCard(
                      totalUsers: controller.totalUsers,
                      totalRevenue: controller.totalRevenue,
                      systemHealth: controller.systemHealth,
                    ),
                    const SizedBox(height: 20),

                    // SỬA ĐỔI 3: Cập nhật cách gọi widget hiển thị ghi chú.
                    // Tên widget là `RecentNotesView`.
                    // Tham số là `notes` (không phải `activities`).
                    // Nguồn dữ liệu là `controller.recentNotes` (không phải `controller.recentActivities`).
                    RecentNotesView(notes: controller.recentNotes),
                  ],
                ),
              ),
            ),
    );
  }
}
