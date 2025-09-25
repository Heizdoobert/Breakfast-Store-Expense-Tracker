import 'package:flutter/material.dart';

// Đổi tên file thành custom_app_bar.dart sẽ giải quyết cảnh báo tên file.

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String imageUrl;
  final bool hasNotification;
  final VoidCallback? onNotificationPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key, // Thêm super.key
    required this.username,
    required this.imageUrl,
    this.hasNotification = false,
    this.onNotificationPressed,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Kích thước AppBar mặc định

  @override
  Widget build(BuildContext context) {
    // Trả về một AppBar tùy chỉnh của Flutter
    return AppBar(
      titleSpacing: 0.0, 
      backgroundColor: Colors.transparent, // Để gradient của flexibleSpace hiển thị
      elevation: 0, // Loại bỏ bóng đổ mặc định
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Sử dụng một tông màu xanh dương làm chủ đạo
            colors: [Color(0xFF007BFF), Color(0xFF0056b3)], // Một sắc độ của blueAccent và một màu xanh đậm hơn
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding cho nội dung bên trong AppBar title
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
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

            // Greeting and name
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

            // Notification icon (nếu không có actions khác)
            if (actions == null && hasNotification) _buildNotificationIcon(),
            // Handle other actions if provided
            if (actions != null)
              ...?actions,
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, size: 26, color: Colors.black),
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
