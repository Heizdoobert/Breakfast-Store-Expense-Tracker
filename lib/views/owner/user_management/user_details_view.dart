import 'package:flutter/material.dart';

class UserDetailView extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết: ${user['userName']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👤 Họ tên: ${user['fullName']}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('📧 Email: ${user['email']}'),
            const SizedBox(height: 8),
            Text('🔐 Vai trò: ${user['role']}'),
            const SizedBox(height: 8),
            Text('🕒 Tạo lúc: ${user['createdAt']}'),
            const SizedBox(height: 8),
            Text('🕒 Cập nhật: ${user['updatedAt']}'),
          ],
        ),
      ),
    );
  }
}