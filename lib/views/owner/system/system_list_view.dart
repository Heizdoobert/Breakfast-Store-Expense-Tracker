import 'package:extractorapplication/views/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/owner/system_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../user_management/user_details_view.dart';

class OwnerSystemOverviewView extends StatelessWidget {
  const OwnerSystemOverviewView({super.key});
  static final DateFormatter formatDate = DateFormatter();

  @override
  Widget build(BuildContext context) {
    final controller  = context.watch<SystemController>();

    if(controller.isLoading)
      {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loadSystemOverview();
        });
      }

    if(controller.isLoading && controller.groups.isEmpty && controller.users.isEmpty)
      {
        return const LoadingIndicator(fullscreen: true, message: 'Đang tải danh sách hệ thống...');
      }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.loadSystemOverview,
        child: SingleChildScrollView( // Dùng SingleChildScrollView để cuộn toàn bộ màn hình
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📦 Danh sách nhóm (${controller.groups.length})',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              // ✅ 4. Dùng ListView.builder cho hiệu năng
              ListView.builder(
                itemCount: controller.groups.length,
                shrinkWrap: true, // Cần thiết khi lồng ListView trong Column
                physics: const NeverScrollableScrollPhysics(), // Tắt cuộn của ListView con
                itemBuilder: (context, index) {
                  final group = controller.groups[index];
                  return Card(
                    child: ListTile(
                      title: Text('🧭 ${group.name ?? 'Nhóm không tên'}'),
                      subtitle: Text('ID: ${group.id ?? 'Không rõ'}'),
                    ),
                  );
                },
              ),
              const Divider(height: 32),
              Text('👥 Thành viên (${controller.users.length})',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              // ✅ 4. Dùng ListView.builder cho hiệu năng
              ListView.builder(
                itemCount: controller.users.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return Card(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailView(user: user, formatDate: formatDate),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}