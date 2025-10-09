import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/system_controller.dart';
import '../../shared/loading_indicator.dart';

class OwnerSystemOverviewView extends StatelessWidget {
  const OwnerSystemOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SystemController>();

    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadSystemOverview();
      });
    }

    return Scaffold(
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, SystemController controller) {
    if (controller.isLoading && controller.groups.isEmpty) {
      return const LoadingIndicator(fullscreen: true, message: 'Đang tải dữ liệu hệ thống...');
    }

    if (controller.groups.isEmpty) {
      return const Center(child: Text('Chưa có nhóm nào được tạo.'));
    }

    return RefreshIndicator(
      onRefresh: controller.loadSystemOverview,
      child: ListView.builder(
        itemCount: controller.groups.length,
        itemBuilder: (context, index) {
          final group = controller.groups[index];
          final members = controller.groupMembers[group.id];
          final isLoadingMembers = controller.loadingGroups.contains(group.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text('🧭 ${group.name ?? 'Nhóm không tên'}'),
              subtitle: Text('ID: ${group.id ?? 'Không rõ'}'),
              onExpansionChanged: (isExpanding) {
                if (isExpanding) {
                  controller.loadMembersForGroup(group.id!);
                }
              },
              children: [
                if (isLoadingMembers)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                if (members != null)
                  if (members.isEmpty && !isLoadingMembers)
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.grey),
                      title: Text('Không có thành viên nào trong nhóm này.'),
                    )
                  else
                    ...members.map((member) => ListTile(
                      leading: const Icon(Icons.person_outline, color: Colors.blueGrey),
                      title: Text(member.fullName ?? member.userName ?? 'Không rõ'),
                      subtitle: Text(member.email ?? 'Không có email'),
                      dense: true,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}