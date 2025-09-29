import 'package:flutter/material.dart';

// Widget AppBar tùy chỉnh, có thể dùng thay thế AppBar mặc định của Flutter
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String imageUrl;
  final bool hasNotification;
  final VoidCallback? onNotificationPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.username,
    required this.imageUrl,
    this.hasNotification = false,
    this.onNotificationPressed,
    this.actions,
  });

  // Thiết lập chiều cao mặc định cho AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      backgroundColor: Colors.transparent, // Cho phép gradient hiển thị
      elevation: 0, // Loại bỏ bóng đổ mặc định
      // Gradient nền cho AppBar
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007BFF), Color(0xFF0056b3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      // Nội dung chính của AppBar
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hiển thị ảnh đại diện người dùng
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 24, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Lời chào và tên người dùng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Xin chào',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Nếu không có actions tùy chỉnh, hiển thị biểu tượng thông báo
            if (actions == null && hasNotification) _buildNotificationIcon(),

            // Nếu có actions tùy chỉnh, hiển thị chúng
            if (actions != null) ...?actions,
          ],
        ),
      ),
    );
  }

  // Widget biểu tượng thông báo có chấm đỏ nếu có thông báo mới
  Widget _buildNotificationIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            size: 26,
            color: Colors.black,
          ),
          onPressed: onNotificationPressed,
        ),
        if (hasNotification)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
