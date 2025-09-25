import 'package:flutter/material.dart';
import '../../Controller/staff/staffController.dart';

class StaffDashboardView extends StatefulWidget {
  final StaffController controller;
  const StaffDashboardView({super.key, required this.controller});

  @override
  State<StaffDashboardView> createState() => _StaffDashboardViewState();
}

class _StaffDashboardViewState extends State<StaffDashboardView> {
  late StaffController staffController;

  // --- Định nghĩa các trang cho Staff Dashboard ---
  // Bạn cần tạo các file tương ứng cho các trang này.
  // Ví dụ:
  final List<Widget> _pages = [
    Center(child: Text('Staff Home')),
    Center(child: Text('Staff Tasks')),
    Center(child: Text('Staff Schedule')),
    Center(child: Text('Staff Profile')),
    Center(child: Text('Staff Settings')),
  ];

  @override
  void initState() {
    super.initState();
    staffController = widget.controller;
  }

  @override
  void dispose() {
    staffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Giả định có TopBarWidget giống Owner
        // title: TopBarWidget(
        //   username: staffController.currentUser.fullName!,
        //   imageUrl: 'https://via.placeholder.com/150',
        //   hasNotification: true,
        // ),
        title: Text('Staff Dashboard'), // Placeholder AppBar
      ),

      body: ValueListenableBuilder<int>(
        valueListenable: staffController.tabController,
        builder: (context, index, _) => _pages[index],
      ),
      // bottomNavigationBar: NavbarBottom(
      //   tabController: staffController.tabController,
      // ),
      bottomNavigationBar: BottomNavigationBar(
         currentIndex: staffController.tabController.value,
         onTap: staffController.changeTab,
         items: const [
           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
           BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
         ],
      ), // Placeholder BottomNavigationBar
    );
  }
}
