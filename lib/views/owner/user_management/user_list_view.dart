import 'package:extractorapplication/views/owner/user_management/user_details_view.dart';
import 'package:flutter/material.dart';

import '../../../Controller/owner/user_management_controller.dart';
import '../../../routes/app_route.dart';
import '../../shared/loading_indicator.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final controller = UserManagementController();

  @override
  void initState() {
    super.initState();
    controller.loadUsers().then((_) =>setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👥 Danh sách người dùng')),
      body: controller.isLoading
          ? const LoadingIndicator(fullscreen: true, message: 'Loading...')
          : ListView.builder(
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user.fullName),
            subtitle: Text('${user.email} - ${user.role}'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.userDetailView,
                );
              },
            ),
          );
        },
      ),
    );
  }
}