import 'package:extractorapplication/views/owner/dashboard/owner_dashboard_view.dart';
import 'package:extractorapplication/views/owner/financial/financial_ovwerview_view.dart';
import 'package:extractorapplication/views/owner/system/system_list_view.dart';
import 'package:extractorapplication/views/owner/user_management/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../Controller/auth_controller.dart';
import '../../Model/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_route.dart';
import '../../utils/constants.dart';
import '../shared/custom_button.dart';


class OwnerNavigationShell extends StatefulWidget {
  const OwnerNavigationShell({super.key});

  @override
  State<OwnerNavigationShell> createState() => _OwnerNavigationShellState();
}

class _OwnerNavigationShellState extends State<OwnerNavigationShell> {
  String currentRoute = AppRoutes.ownerDashboard;

  final Map<String, Widget> routeToPage ={
    AppRoutes.ownerDashboard: const OwnerDashboardView(),
    AppRoutes.userListView: const UserListView(),
    AppRoutes.financialOverviewView: const FinancialOverviewView(),
    AppRoutes.systemLists: OwnerSystemOverviewView(),
  };

  final Map<String, String> routeToTitle = const {
    AppRoutes.ownerDashboard: '📊 Thống kê tổng quan',
    AppRoutes.userListView: '👥 Quản lý người dùng',
     AppRoutes.financialOverviewView: '💰 Tài chính',
    AppRoutes.systemLists: '⚙️ Hệ thống',
  };

  void _navigateTo(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  void handleLogout(BuildContext context) async {
    final authController = AuthController();

    try {
      await authController.logout(); // Gọi logout từ AuthService nếu có

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false, // Xóa toàn bộ stack
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng xuất: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = [
      AppRoutes.ownerDashboard,
      AppRoutes.userListView,
      AppRoutes.financialOverviewView,
      AppRoutes.systemLists,
    ].indexOf(currentRoute);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          routeToTitle[currentRoute] ?? 'Không có tiêu đề',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LogoutButton(
              onPressed: () => handleLogout(context),
              isGradient: true,
              width: 20,
              height: 20,
              borderRadius: 20,
            ),
          ),
        ],
        elevation: 2,
      ),
      body: routeToPage[currentRoute] ?? const Center(child: Text('No page found')),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPallete.backgroundColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: (i) => setState(() => _navigateTo([
              AppRoutes.ownerDashboard,
              AppRoutes.userListView,
              AppRoutes.financialOverviewView,
              AppRoutes.systemLists,
        ][i])),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppPallete.gradient1,
        unselectedItemColor: AppPallete.gradient2,
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(AppIcons.person), label: 'Người dùng'),
          BottomNavigationBarItem(icon: Icon(AppIcons.money), label: 'Tài chính'),
          BottomNavigationBarItem(icon: Icon(AppIcons.settings), label: 'Hệ thống'),
        ],
      ),
    );
  }


}