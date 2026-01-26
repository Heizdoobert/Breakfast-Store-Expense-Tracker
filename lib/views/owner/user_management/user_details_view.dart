// G:/Project/Breakfast-Store-Expense-Tracker/lib/views/owner/user_management/user_details_view.dart

import 'package:extractorapplication/Model/user_model.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../routes/app_route.dart';

class UserDetailView extends StatelessWidget {
  final User user;
  final DateFormatter formatDate;

  const UserDetailView({
    super.key,
    required this.user,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết: ${user.displayName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 Họ tên: ${user.displayName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('📧 Email: ${user.email}'),
            const SizedBox(height: 8),
            Text('🔐 Vai trò: ${user.role}'),
            const SizedBox(height: 8),
            Text('🕒 Tạo lúc: ${formatDate.timeAgo(user.createdAt)}'),
            const SizedBox(height: 8),
            Text('🕒 Cập nhật: ${formatDate.timeAgo(user.updatedAt)}'),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addUsers,
                        arguments: user);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.editUsers,
                        arguments: user);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Sửa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content:
                            const Text('Bạn có chắc muốn xóa người dùng này?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Xóa',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
