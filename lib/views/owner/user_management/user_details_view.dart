import 'package:flutter/material.dart';

import '../../../utils/date_formatter.dart';

class UserDetailView extends StatelessWidget {
  final Map<String, dynamic> user;
  final DateFormatter formatDate;

  const UserDetailView({super.key, required this.user, required this.formatDate});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết: ${user['userName']}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👤 Họ tên: ${user['fullName'] ?? 'Khong co thong tin'}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('📧 Email: ${user['email']}'),
            const SizedBox(height: 8),
            Text('🔐 Vai trò: ${user['role']}'),
            const SizedBox(height: 8),
            Text('🕒 Tạo lúc: ${formatDate.timeAgo(user['createdAt'])}'),
            const SizedBox(height: 8),
            Text('🕒 Cập nhật: ${formatDate.timeAgo(user['updatedAt'])}'),
          ],
        ),
      ),
    );
  }
}