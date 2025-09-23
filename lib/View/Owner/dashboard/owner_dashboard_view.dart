import 'package:extractorapplication/Controller/owner/owner_dashboard_controller.dart';
import 'package:extractorapplication/routes/app_route.dart';
import 'package:extractorapplication/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  // ============ APP BAR ============
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Owner Dashboard'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(AppIcons.notifications),
          onPressed: controller.showNotifications,
          tooltip: 'Thông báo',
        ),
        IconButton(
          icon: const Icon(AppIcons.logout),
          onPressed: controller.logout,
          tooltip: 'Đăng xuất',
        ),
      ],
    );
  }

  // ============ DRAWER ============
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            title: 'Tổng quan',
            icon: AppIcons.dashboard,
            route: AppRoutes.ownerDashboard,
          ),
          _buildDrawerItem(
            title: 'Quản lý Người dùng',
            icon: AppIcons.users,
            route: AppRoutes.ownerUserList,
          ),
          _buildDrawerItem(
            title: 'Tài chính',
            icon: AppIcons.money,
            route: AppRoutes.ownerFinancialOverview,
          ),
          _buildDrawerItem(
            title: 'Báo cáo Doanh thu',
            icon: AppIcons.analytics,
            route: AppRoutes.ownerRevenueReport,
          ),
          const Divider(),
          _buildDrawerItem(
            title: 'Cài đặt Hệ thống',
            icon: AppIcons.settings,
            route: AppRoutes.ownerSystemSettings,
          ),
          _buildDrawerItem(
            title: 'Thông tin Ứng dụng',
            icon: AppIcons.info,
            route: '/about',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              AppIcons.person,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            controller.currentUser?.fullName ?? 'Owner',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            controller.currentUser?.role.toUpperCase() ?? 'OWNER',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: () {
        Get.back(); // Đóng drawer
        if (Get.currentRoute != route) {
          Get.toNamed(route);
        }
      },
      tileColor: Get.currentRoute == route
          ? AppColors.primary.withOpacity(0.1)
          : null,
    );
  }

  // ============ BODY ============
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 20),
          _buildStatsGrid(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  // ============ WELCOME SECTION ============
  Widget _buildWelcomeSection() {
    return Obx(() => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng trở lại, ${controller.currentUser?.fullName ?? 'Owner'}!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dưới đây là tổng quan hệ thống của bạn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildSystemStatus(),
          ],
        ),
      ),
    ));
  }

  Widget _buildSystemStatus() {
    return Obx(() => Row(
      children: [
        Icon(
          controller.isSystemHealthy.value ? Icons.check_circle : Icons.error,
          color: controller.isSystemHealthy.value ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          controller.isSystemHealthy.value
              ? 'Hệ thống hoạt động bình thường'
              : 'Có vấn đề với hệ thống',
          style: TextStyle(
            color: controller.isSystemHealthy.value ? Colors.green : Colors.red,
            fontSize: 12,
          ),
        ),
      ],
    ));
  }

  // ============ STATS GRID ============
  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          title: 'Tổng Người dùng',
          value: controller.totalUsers.value.toString(),
          icon: AppIcons.users,
          color: Colors.blue,
          onTap: () => Get.toNamed(AppRoutes.ownerUserList),
        ),
        _buildStatCard(
          title: 'Tổng Nhóm',
          value: controller.totalGroups.value.toString(),
          icon: AppIcons.group,
          color: Colors.green,
          onTap: () => Get.toNamed(AppRoutes.adminGroupList),
        ),
        _buildStatCard(
          title: 'Doanh thu Tháng',
          value: '${controller.monthlyRevenue.value} VND',
          icon: AppIcons.money,
          color: Colors.orange,
          onTap: () => Get.toNamed(AppRoutes.ownerRevenueReport),
        ),
        _buildStatCard(
          title: 'Chi phí Tháng',
          value: '${controller.monthlyExpenses.value} VND',
          icon: AppIcons.payment,
          color: Colors.red,
          onTap: () => Get.toNamed(AppRoutes.ownerFinancialOverview),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ QUICK ACTIONS ============
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thao tác Nhanh',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickActionButton(
              label: 'Thêm User',
              icon: AppIcons.userAdd,
              onPressed: () => Get.toNamed(AppRoutes.ownerUserCreate),
              color: Colors.blue,
            ),
            _buildQuickActionButton(
              label: 'Báo cáo',
              icon: AppIcons.analytics,
              onPressed: controller.generateReport,
              color: Colors.green,
            ),
            _buildQuickActionButton(
              label: 'Sao lưu',
              icon: Icons.backup,
              onPressed: controller.createBackup,
              color: Colors.orange,
            ),
            _buildQuickActionButton(
              label: 'Cài đặt',
              icon: AppIcons.settings,
              onPressed: () => Get.toNamed(AppRoutes.ownerSystemSettings),
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ RECENT ACTIVITY ============
  Widget _buildRecentActivity() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hoạt động Gần đây',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: controller.viewAllActivities,
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Expanded(
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.recentActivities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              itemCount: controller.recentActivities.length,
              itemBuilder: (context, index) {
                final activity = controller.recentActivities[index];
                return _buildActivityItem(activity);
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getActivityColor(activity['type']),
          child: Icon(
            _getActivityIcon(activity['type']),
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text(activity['title'] ?? ''),
        subtitle: Text(activity['description'] ?? ''),
        trailing: Text(
          activity['time'] ?? '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () => _handleActivityTap(activity),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.analytics, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có hoạt động nào',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ============ ACTIVITY HELPER METHODS ============
  Color _getActivityColor(String type) {
    switch (type) {
      case 'user':
        return Colors.blue;
      case 'financial':
        return Colors.green;
      case 'system':
        return Colors.orange;
      case 'warning':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'user':
        return AppIcons.users;
      case 'financial':
        return AppIcons.money;
      case 'system':
        return AppIcons.settings;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    final type = activity['type'];
    switch (type) {
      case 'user':
        Get.toNamed(AppRoutes.ownerUserList);
        break;
      case 'financial':
        Get.toNamed(AppRoutes.ownerFinancialOverview);
        break;
      case 'system':
        Get.toNamed(AppRoutes.ownerSystemSettings);
        break;
      default:
        break;
    }
  }
}