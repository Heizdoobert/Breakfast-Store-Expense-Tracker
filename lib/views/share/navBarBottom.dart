import 'package:flutter/material.dart';

import '../../utils/valueNotifier.dart';

class NavbarBottom extends StatelessWidget {
  final TabNotifier tabController;

  const NavbarBottom({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      // Theo dõi sự thay đổi tab hiện tại
      valueListenable: tabController,
      builder: (context, selectedIndex, _) {
        return ClipRRect(
          // Bo góc phía trên của thanh điều hướng
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            // Thiết lập nền gradient và hiệu ứng đổ bóng
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
              // Tab đang được chọn
              currentIndex: selectedIndex,
              // Hàm xử lý khi người dùng chọn tab khác
              onTap: tabController.changeTab,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              showUnselectedLabels: true,
              elevation: 0, // Xóa viền nổi mặc định
              // Các mục trong thanh điều hướng
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ', // Mục 1: Home
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note),
                  label: 'Ghi chú', // Mục 2: Notes
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Chi phí', // Mục 3: Expenses
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Hồ sơ', // Mục 4: Profile
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Cài đặt', // Mục 5: Settings
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
