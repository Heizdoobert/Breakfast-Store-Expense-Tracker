import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/owner/system_controller.dart';
import '../../shared/loading_indicator.dart';

// Chuyển thành StatefulWidget để quản lý việc tải dữ liệu ban đầu tốt hơn
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
    // Sử dụng context.read() trong initState để gọi hàm một lần mà không gây ra vòng lặp build
    final controller = context.read<SystemController>();
    if (controller.shouldLoadData) {
      // Dùng addPostFrameCallback để đảm bảo context đã sẵn sàng
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Chỉ gọi hàm load nếu cần, tránh gọi lại không cần thiết
        if (mounted) {
          controller.loadSystemOverview();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dùng context.watch() trong build để lắng nghe thay đổi và cập nhật UI
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
          // group.id bây giờ là int, cần đảm bảo controller.groupMembers dùng Map<int, ...>
          final members = controller.groupMembers[group.id];
          final isLoadingMembers = controller.loadingGroups.contains(group.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              // Bỏ các toán tử `??` vì `id` và `name` không thể null
              title: Text('🧭 ${group.name}'),
              subtitle: Text('ID: ${group.id}'),
              onExpansionChanged: (isExpanding) {
                if (isExpanding && members == null) {
                  // Chỉ load nếu chưa có dữ liệu
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
                          // Giữ lại `??` ở đây vì thông tin user có thể null
                          title: Text(member.fullName ??
                              member.userName ??
                              'Người dùng không tên'),
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
