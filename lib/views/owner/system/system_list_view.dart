import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/system_controller.dart';
import '../../../routes/app_route.dart';
import '../../../utils/date_formatter.dart';

class OwnerSystemOverviewView extends StatelessWidget {
  final formatDate = DateFormatter();
  OwnerSystemOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SystemController()..loadSystemOverview(),
      child: Consumer<SystemController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📦 Danh sách nhóm (${controller.groups.length})',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...controller.groups.map((group) => Card(
                      child: ListTile(
                        title: Text('🧭 ${group.name ?? 'Nhóm không tên'}'),
                        subtitle: Text('ID: ${group.id ?? 'Không rõ'}'),
                      ),
                    )),
                    const Divider(height: 32),
                    Text('👥 Thành viên (${controller.users.length})',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...controller.users.map((user) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user.userName ?? 'Không rõ'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📧 Email: ${user.email ?? 'Không rõ'}'),
                            Text('🛡 Vai trò: ${user.role ?? 'Không rõ'}'),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: mở chi tiết người dùng hoặc sửa
                          Navigator.pushNamed(context, AppRoutes.userDetailView, arguments: user);
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}