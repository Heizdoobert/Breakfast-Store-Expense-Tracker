import 'package:flutter/material.dart';
import '../../routes/app_route.dart';
import '../../utils/constants.dart';


class OwnerNavigationShell extends StatefulWidget {
  const OwnerNavigationShell({super.key});

  @override
  State<OwnerNavigationShell> createState() => _OwnerNavigationShellState();
}

class _OwnerNavigationShellState extends State<OwnerNavigationShell> {

  void _navigate(BuildContext context, int index) {
    final routes = [
      AppRoutes.ownerDashboard,
      AppRoutes.userListView,
      // AppRoutes.systemView,
      // AppRoutes.financialView,
    ];
    Navigator.pushNamed(context, routes[index]);
  }


  final List<String> titles = [
    '📊 Thống kê tổng quan',
    '👥 Quản lý người dùng',
    '⚙️ Hệ thống',
    '💰 Tài chính',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏠 Trang chủ Owner')),
      body: const Center(child: Text('Chọn một mục bên dưới')),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _navigate(context, index),
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