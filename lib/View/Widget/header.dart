import 'package:extractorapplication/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final auth = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final initials = user?.full_name != null && user!.full_name!.isNotEmpty
        ? user.full_name?.split(' ').map((n) => n[0]).take(2).join()
        : 'U';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button with improved design
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () {
                // TODO: thêm action menu
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.menu_rounded,
                  color: Colors.teal.shade700,
                  size: 24,
                ),
              ),
            ),
          ),

          // User Info in the center
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Chào mừng",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.full_name ?? "Người dùng",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // User Avatar with notification badge
          Stack(
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: () {
                    // TODO: mở trang thông báo hoặc profile
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.teal.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initials!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Notification badge
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}