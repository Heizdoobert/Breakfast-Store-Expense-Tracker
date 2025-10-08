import 'package:extractorapplication/core/theme/app_theme.dart';
import 'package:extractorapplication/views/owner/user_management/user_details_view.dart';
import 'package:flutter/material.dart';

import '../../../Controller/owner/user_management_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../../shared/loading_indicator.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final controller = UserManagementController();
  final formatDate = DateFormatter();

  @override
  void initState() {
    super.initState();
    controller.loadUsers().then((_) =>setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: controller.isLoading ? const LoadingIndicator(
          fullscreen: true,
          message: 'Loading...',
        ) : ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: const CircleAvatar(
                        backgroundColor: AppPallete.backgroundColor,
                        child: Icon(Icons.person)
                    ),
                  title: Text(
                    user.fullName ?? 'Không rõ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${user.email ?? 'Không rõ'} • ${user.role ?? 'Không rõ'}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailView(
                          user: user,
                          formatDate: formatDate,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
        ),
    );
  }
}
