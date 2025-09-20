import 'package:flutter/material.dart';

class MoreHomePage extends StatelessWidget {
  const MoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("⚙️ Tùy chọn"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Thông tin tài khoản
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person, color: Colors.white),
              backgroundColor: Colors.teal,
            ),
            title: const Text("Thông tin tài khoản"),
            subtitle: const Text("Xem & chỉnh sửa thông tin cá nhân"),
            onTap: () {
              // TODO: điều hướng sang trang thông tin tài khoản
            },
          ),
          const Divider(),

          /// Cài đặt
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.settings, color: Colors.white),
              backgroundColor: Colors.blueGrey,
            ),
            title: const Text("Cài đặt"),
            subtitle: const Text("Tùy chỉnh ứng dụng"),
            onTap: () {
              // TODO: mở trang cài đặt
            },
          ),
          const Divider(),

          /// Hỗ trợ
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.help_outline, color: Colors.white),
              backgroundColor: Colors.orange,
            ),
            title: const Text("Hỗ trợ"),
            subtitle: const Text("Câu hỏi thường gặp & liên hệ"),
            onTap: () {
              // TODO: mở trang hỗ trợ
            },
          ),
          const Divider(),

          /// Đăng xuất
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.logout, color: Colors.white),
              backgroundColor: Colors.redAccent,
            ),
            title: const Text("Đăng xuất"),
            onTap: () {
              // TODO: thêm logic đăng xuất
            },
          ),
        ],
      ),
    );
  }
}
