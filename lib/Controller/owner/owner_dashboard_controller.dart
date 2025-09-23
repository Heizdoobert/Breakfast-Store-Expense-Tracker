import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../services/owner/owner_dashboard_service.dart';

class OwnerDashboardController extends GetxController {
  final AuthServices authService;
  final OwnerDashboardService dashboardService;

  OwnerDashboardController(this.authService, this.dashboardService);

  // Current user
  var currentUser = Rxn(null);

  // Statistics
  var totalUsers = 0.obs;
  var totalGroups = 0.obs;
  var monthlyRevenue = 0.0.obs;
  var monthlyExpenses = 0.0.obs;

  // System status
  var isSystemHealthy = true.obs;
  var isLoading = false.obs;

  // Recent activities
  var recentActivities = [].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    _loadDashboardData();
  }

  void _loadCurrentUser() {
    currentUser.value = authService.getCurrentUser() as Null;
  }

  Future<void> _loadDashboardData() async {
    isLoading.value = true;
    try {
      // Load statistics
      final stats = await dashboardService.getDashboardStatistics();
      totalUsers.value = stats['totalUsers'] ?? 0;
      totalGroups.value = stats['totalGroups'] ?? 0;
      monthlyRevenue.value = stats['monthlyRevenue'] ?? 0.0;
      monthlyExpenses.value = stats['monthlyExpenses'] ?? 0.0;

      // Load recent activities
      final activities = await dashboardService.getRecentActivities();
      recentActivities.value = activities;

      // Check system health
      isSystemHealthy.value = await dashboardService.checkSystemHealth();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============ ACTIONS ============
  void showNotifications() {
    Get.toNamed('/notifications');
  }

  void logout() {
    authService.logout();
  }

  void generateReport() {
    // Logic để generate report
    Get.snackbar('Thông báo', 'Đang tạo báo cáo...');
  }

  void createBackup() {
    // Logic để tạo backup
    Get.snackbar('Thông báo', 'Đang tạo sao lưu...');
  }

  void viewAllActivities() {
    Get.toNamed('/activities');
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadDashboardData();
  }
}