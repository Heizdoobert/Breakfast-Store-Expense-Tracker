import '../../services/owner/owner_financial_service.dart';
import '../../services/owner/owner_system_service.dart';
import '../../services/owner/owner_user_service.dart';

class OwnerDashboardController {
  int totalUsers = 0;
  double totalRevenue =0.0;
  String systemHealth = 'Checking ...';
  List<String> recentActivities = [];
  bool isLoading = true;

  void dispose() {
    isLoading = false;
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading = true;
      totalUsers = await OwnerUserService().getUserCount();
      totalRevenue = await OwnerFinancialService().getTotalRevenue();
      systemHealth = await OwnerSystemService().getSystemHealth();
      recentActivities = await OwnerUserService().getRecentActivities();
      isLoading = false;
    }catch (e) {
      isLoading = false;
      throw Exception('Error loading dashboard data: $e');
    }
  }
}