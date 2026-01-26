import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/system_controller.dart';
import '../../shared/loading_indicator.dart';

class OwnerSystemOverviewView extends StatefulWidget {
  const OwnerSystemOverviewView({super.key});

  @override
  State<OwnerSystemOverviewView> createState() =>
      _OwnerSystemOverviewViewState();
}

class _OwnerSystemOverviewViewState extends State<OwnerSystemOverviewView> {
  @override
  void initState() {
    super.initState();
    final controller = context.read<SystemController>();
    if (controller.shouldLoadData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          controller.loadSystemOverview();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SystemController>();
    return Scaffold(
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, SystemController controller) {
    if (controller.isLoading && controller.groups.isEmpty) {
      return const LoadingIndicator(
          fullscreen: true, message: 'Đang tải dữ liệu hệ thống...');
    }

    if (controller.groups.isEmpty && !controller.isLoading) {
      return RefreshIndicator(
        onRefresh: controller.loadSystemOverview,
        child: const Center(child: Text('Chưa có nhóm nào được tạo.')),
      );
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
              title: Text('🧭 ${group.name}'),
              subtitle: Text('ID: ${group.id}'),
              onExpansionChanged: (isExpanding) {
                if (isExpanding && members == null) {
                  controller.loadMembersForGroup(group.id);
                }
              },
              children: [
                if (isLoadingMembers)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (members != null)
                  if (members.isEmpty && !isLoadingMembers)
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.grey),
                      title: Text('Không có thành viên nào trong nhóm này.'),
                    )
                  else
                    ...members.map((member) => ListTile(
                          leading: const Icon(Icons.person_outline,
                              color: Colors.blueGrey),
                          // === SỬA ĐỔI: Sử dụng getter displayName mới ===
                          title: Text(member.displayName),
                          subtitle: Text(member.email),
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
