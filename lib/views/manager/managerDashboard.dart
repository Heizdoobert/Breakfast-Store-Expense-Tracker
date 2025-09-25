import 'package:flutter/material.dart';
import '../../Controller/manager/managerController.dart';

class ManagerDashboardView extends StatefulWidget {
  final ManagerController controller;
  const ManagerDashboardView({super.key, required this.controller});

  @override
  State<ManagerDashboardView> createState() => _ManagerDashboardViewState();
}

class _ManagerDashboardViewState extends State<ManagerDashboardView> {
  late ManagerController managerController;

  // --- Định nghĩa các trang cho Manager Dashboard ---
  // Bạn cần tạo các file tương ứng cho các trang này.
  // Ví dụ:
  final List<Widget> _pages = [
    Center(child: Text('Manager Home')),
    Center(child: Text('Manager Reports')),
    Center(child: Text('Manager Team')),
    Center(child: Text('Manager Profile')),
    Center(child: Text('Manager Settings')),
  ];

  @override
  void initState() {
    super.initState();
    managerController = widget.controller;
  }

  @override
  void dispose() {
    managerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Giả định có TopBarWidget giống Owner
        // title: TopBarWidget(
        //   username: managerController.currentUser.fullName!,
        //   imageUrl: 'https://via.placeholder.com/150',
        //   hasNotification: true,
        // ),
        title: Text('Manager Dashboard'), // Placeholder AppBar
      ),

      body: ValueListenableBuilder<int>(
        valueListenable: managerController.tabController,
        builder: (context, index, _) => _pages[index],
      ),
      // bottomNavigationBar: NavbarBottom(
      //   tabController: managerController.tabController,
      // ),
      bottomNavigationBar: BottomNavigationBar(
         currentIndex: managerController.tabController.value,
         onTap: managerController.changeTab,
         items: const [
           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
         ],
      ), // Placeholder BottomNavigationBar
    );
  }
}
