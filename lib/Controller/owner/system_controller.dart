import 'package:extractorapplication/Model/group_model.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/user_model.dart';
import '../../core/services/owner/system_service.dart';
import '../base_controller.dart';

/// Controller sử dụng Provider để lắng nghe, quản lý dữ liệu hệ thống (nhóm, người dùng).
class SystemController extends BaseController {
  final SystemService _service;
  SystemController(this._service);

  List<Group> groups = [];
  List<User> users = [];

  // === SỬA LỖI 1: Thay đổi kiểu dữ liệu của key từ String sang int ===
  Map<int, List<User>> groupMembers = {};
  Set<int> loadingGroups = {};

  Future<void> _fetchData() async {
    try {
      // Gọi song song để tăng tốc độ
      final results = await Future.wait([
        _service.getGroups(),
        _service.getUsers(),
      ]);

      // === SỬA LỖI 2: Ép kiểu an toàn hơn ===
      // Kết quả của Future.wait là List<dynamic>, cần ép kiểu từng phần tử
      groups = results[0] as List<Group>;
      users = results[1] as List<User>;
    } catch (e) {
      // Ném lại lỗi để hàm loadData có thể bắt và xử lý
      debugPrint('Lỗi nghiêm trọng khi fetch data hệ thống: $e');
      rethrow;
    }
  }

  /// Tải dữ liệu tổng quan của hệ thống (danh sách nhóm và người dùng).
  Future<void> loadSystemOverview() async {
    // Sử dụng hàm loadData từ BaseController để quản lý trạng thái isLoading và error
    await loadData(_fetchData);
  }

  // Hàm tiện ích để thực hiện hành động và quản lý trạng thái loading
  Future<bool> _performAction(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('SystemController Error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // === SỬA LỖI 1: Thay đổi kiểu dữ liệu của groupId từ String sang int ===
  Future<void> addUserToGroup(
      {required String userId, required int groupId}) async {
    await _performAction(() async {
      await _service.addUserToGroup(userId, groupId);
      // === SỬA LỖI 3: Tải lại chỉ dữ liệu cần thiết thay vì toàn bộ hệ thống ===
      await loadMembersForGroup(groupId, forceReload: true);
    });
  }

  // === SỬA LỖI 1: Thay đổi kiểu dữ liệu của groupId từ String sang int ===
  Future<void> removeUserFromGroup(
      {required String userId, required int groupId}) async {
    await _performAction(() async {
      await _service.removeUserFromGroup(userId, groupId);
      // === SỬA LỖI 3: Tải lại chỉ dữ liệu cần thiết ===
      await loadMembersForGroup(groupId, forceReload: true);
    });
  }

  // === SỬA LỖI 1: Thay đổi kiểu dữ liệu của groupId từ String sang int ===
  // Thêm tham số forceReload để buộc tải lại dữ liệu khi cần (sau khi thêm/xóa thành viên)
  Future<void> loadMembersForGroup(int groupId,
      {bool forceReload = false}) async {
    // Nếu đã có dữ liệu và không bị buộc tải lại, thì không làm gì cả
    if (groupMembers.containsKey(groupId) && !forceReload) return;

    loadingGroups.add(groupId);
    notifyListeners();

    try {
      final members = await _service.getMembersOfGroup(groupId);
      groupMembers[groupId] = members;
    } catch (e) {
      debugPrint('Lỗi khi tải thành viên cho nhóm $groupId: $e');
      groupMembers[groupId] = []; // Gán danh sách rỗng nếu có lỗi
    } finally {
      loadingGroups.remove(groupId);
      notifyListeners();
    }
  }
}
