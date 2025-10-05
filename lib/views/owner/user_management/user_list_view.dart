import 'package:extractorapplication/core/theme/app_theme.dart';
import 'package:extractorapplication/views/owner/user_management/user_details_view.dart';
import 'package:flutter/material.dart';

import '../../../Controller/owner/user_management_controller.dart';
import '../../../routes/app_route.dart';
import '../../../utils/constants.dart';
import '../../../utils/date_formatter.dart';
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
              return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.fullName ?? 'Không rõ'),
                  subtitle: Text(
                      '${user.email ?? 'Không rõ'} - ${user.role ??
                          'Không rõ'}'),
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
              );
            },
        ),
    );
  }
}
