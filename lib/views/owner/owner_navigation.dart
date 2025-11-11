import 'package:extractorapplication/views/owner/dashboard/owner_dashboard_view.dart';
import 'package:extractorapplication/views/owner/financial/financial_ovwerview_view.dart';
import 'package:extractorapplication/views/owner/system/system_list_view.dart';
import 'package:extractorapplication/views/owner/user_management/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

import '../../Controller/auth_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../shared/custom_button.dart';
import '../shared/widgets/creation_speed_dial.dart'; // Import the new widget

class OwnerNavigationShell extends StatefulWidget {
  const OwnerNavigationShell({super.key});

  @override
  State<OwnerNavigationShell> createState() => _OwnerNavigationShellState();
}

class _OwnerNavigationShellState extends State<OwnerNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const OwnerDashboardView(),
    const UserListView(),
    const FinancialScreen(),
    const OwnerSystemOverviewView(),
  ];

  final List<String> _pageTitles = const [
    '📊 Thống kê tổng quan',
    '👥 Quản lý người dùng',
    '💰 Tài chính',
    '⚙️ Hệ thống',
  ];

  void handleLogout() {
    Provider.of<AuthController>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LogoutButton(
              onPressed: handleLogout,
              isGradient: true,
              width: 20,
              height: 20,
              borderRadius: 20,
            ),
          ),
        ],
        elevation: 2,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: const CreationSpeedDial(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPallete.backgroundColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppPallete.gradient1,
        unselectedItemColor: AppPallete.gradient2,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(AppIcons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(AppIcons.person), label: 'Người dùng'),
          BottomNavigationBarItem(
              icon: Icon(AppIcons.money), label: 'Tài chính'),
          BottomNavigationBarItem(
              icon: Icon(AppIcons.settings), label: 'Hệ thống'),
        ],
      ),
    );
  }
}
