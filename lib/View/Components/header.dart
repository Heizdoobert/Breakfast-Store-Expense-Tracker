import 'package:flutter/material.dart';
import 'package:extractorapplication/Controller/AuthController.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300,width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Nút bên trái (Menu)
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 4, // tạo độ nổi
            shadowColor: Colors.black26,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // TODO: thêm action menu
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.dashboard, color: Colors.black87),
              ),
            ),
          ),

          /// Tiêu đề ở giữa
          Text(
            "${auth.currentUser?.full_name}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black87,
            ),
          ),

          /// Nút bên phải (Thông báo / Avatar)
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 4,
            shadowColor: Colors.black26,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // TODO: mở trang thông báo
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.notifications, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
