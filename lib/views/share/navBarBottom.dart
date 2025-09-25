import 'package:flutter/material.dart';
import '../../utils/valueNotifier.dart';

class NavbarBottom extends StatelessWidget {
  final TabNotifier tabController;

  const NavbarBottom({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabController,
      builder: (context, selectedIndex, _) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: tabController.changeTab,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              showUnselectedLabels: true,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
                BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Ghi chú'),
                BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Chi phí'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
              ],
            ),
          ),
        );
      },
    );
  }
}