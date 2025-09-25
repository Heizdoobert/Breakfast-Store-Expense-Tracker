import 'package:flutter/material.dart';
import '../../Controller/kitchen/kitchenController.dart';

class KitchenDashboardView extends StatefulWidget {
  final KitchenController controller;
  const KitchenDashboardView({super.key, required this.controller});

  @override
  State<KitchenDashboardView> createState() => _KitchenDashboardViewState();
}

class _KitchenDashboardViewState extends State<KitchenDashboardView> {
  late KitchenController kitchenController;

  // --- Định nghĩa các trang cho Kitchen Dashboard ---
  // Bạn cần tạo các file tương ứng cho các trang này.
  // Ví dụ:
  final List<Widget> _pages = [
    Center(child: Text('Kitchen Home')),
    Center(child: Text('Kitchen Orders')),
    Center(child: Text('Kitchen Inventory')),
    Center(child: Text('Kitchen Profile')),
    Center(child: Text('Kitchen Settings')),
  ];

  @override
  void initState() {
    super.initState();
    kitchenController = widget.controller;
  }

  @override
  void dispose() {
    kitchenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Giả định có TopBarWidget giống Owner
        // title: TopBarWidget(
        //   username: kitchenController.currentUser.fullName!,
        //   imageUrl: 'https://via.placeholder.com/150',
        //   hasNotification: true,
        // ),
        title: Text('Kitchen Dashboard'), // Placeholder AppBar
      ),

      body: ValueListenableBuilder<int>(
        valueListenable: kitchenController.tabController,
        builder: (context, index, _) => _pages[index],
      ),
      // bottomNavigationBar: NavbarBottom(
      //   tabController: kitchenController.tabController,
      // ),
      bottomNavigationBar: BottomNavigationBar(
         currentIndex: kitchenController.tabController.value,
         onTap: kitchenController.changeTab,
         items: const [
           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
           BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
           BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
         ],
      ), // Placeholder BottomNavigationBar
    );
  }
}
