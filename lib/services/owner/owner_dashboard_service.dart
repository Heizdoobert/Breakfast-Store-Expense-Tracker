class OwnerDashboardService {
  Future getDashboardStatistics() async {}

  Future getRecentActivities() async {}

  Future<bool> checkSystemHealth() async {
    try {
      // Thực hiện kiểm tra hệ thống ở đây
      return true;
    } catch (e) {
      return false;
    }
  }

}