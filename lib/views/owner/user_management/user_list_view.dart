import 'package:extractorapplication/core/theme/app_theme.dart';
import 'package:extractorapplication/views/owner/user_management/user_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/user_management_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../../shared/loading_indicator.dart';

///View hien thi danh sach nguoi dung da duoc dang ky trong db
///lay controller tu provider de xem su thay doi
///chay widget 1 lan
/// Dùng addPostFrameCallback để tránh gọi setState trong lúc build
/// xay dung UI dua tren trang thai cua controller
class UserListView extends StatelessWidget {
  const UserListView({super.key});

  static final DateFormatter _formatDate = DateFormatter();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserManagementController>();

    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadUsers();
      });
    }

    return Scaffold(
      body: controller.isLoading && controller.users.isEmpty
          ? const LoadingIndicator(
              fullscreen: true,
              message: 'Đang tải danh sách người dùng...',
            )
          : RefreshIndicator(
              onRefresh: controller.loadUsers,
              child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: const CircleAvatar(
                          backgroundColor: AppPallete.backgroundColor,
                          child: Icon(Icons.person)),
                      title: Text(
                        user.fullName ?? 'Không rõ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${user.email} • ${user.role}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailView(
                              user: user,
                              formatDate: _formatDate,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
