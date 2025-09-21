import 'package:flutter/material.dart';
import 'package:extractorapplication/View/Components/header.dart';

class MoreHomePage extends StatelessWidget {
  const MoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Header(),

            /// Nội dung chính
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 16),

                  /// Tiêu đề
                  const Text(
                    "⚙️ Tùy chọn",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Thông tin tài khoản
                  _buildOptionCard(
                    icon: Icons.person_rounded,
                    title: "Thông tin tài khoản",
                    subtitle: "Xem & chỉnh sửa thông tin cá nhân",
                    color: Colors.teal,
                    onTap: () {
                      // TODO: điều hướng sang trang thông tin tài khoản
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Cài đặt
                  _buildOptionCard(
                    icon: Icons.settings_rounded,
                    title: "Cài đặt",
                    subtitle: "Tùy chỉnh ứng dụng",
                    color: Colors.blueGrey,
                    onTap: () {
                      // TODO: mở trang cài đặt
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Hỗ trợ
                  _buildOptionCard(
                    icon: Icons.help_outline_rounded,
                    title: "Hỗ trợ",
                    subtitle: "Câu hỏi thường gặp & liên hệ",
                    color: Colors.orange,
                    onTap: () {
                      // TODO: mở trang hỗ trợ
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Đăng xuất
                  _buildOptionCard(
                    icon: Icons.logout_rounded,
                    title: "Đăng xuất",
                    subtitle: "Thoát khỏi tài khoản hiện tại",
                    color: Colors.redAccent,
                    onTap: () {
                      // TODO: thêm logic đăng xuất
                    },
                  ),
                  const SizedBox(height: 24),

                  /// Thông tin ứng dụng
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Thông tin ứng dụng",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Phiên bản"),
                            Text(
                              "1.0.0",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Nhà phát triển"),
                            Text(
                              "Heizdoobert",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}