import 'package:extractorapplication/views/owner/user_management/user_list_view.dart';
import 'package:flutter/material.dart';

import '../../../../routes/app_route.dart';
import '../../../../utils/constants.dart';
import '../owner_dashboard_view.dart';

class OwnerNavigationView extends StatefulWidget {
  const OwnerNavigationView({super.key});

  @override
  State<OwnerNavigationView> createState() => _OwnerNavigationViewState();
}

class _OwnerNavigationViewState extends State<OwnerNavigationView> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    OwnerDashboardView(),
    UserListView(),
    // FinancialManagementView(),
    // NoteManagementView(),
    // SystemManagementView(),
  ];

  final List<String> routes = [
    AppRoutes.ownerDashboard,
    AppRoutes.userListView,
  ];

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  Navigator.pushNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(AppIcons.person), label: 'Người dùng'),
          BottomNavigationBarItem(icon: Icon(AppIcons.settings), label: 'Hệ thống'),
          BottomNavigationBarItem(icon: Icon(AppIcons.money), label: 'Tài chính'),
        ],
      ),
    );
  }

}