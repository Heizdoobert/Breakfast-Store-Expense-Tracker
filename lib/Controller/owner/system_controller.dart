import 'package:extractorapplication/Model/group_model.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/user_model.dart';
import '../../core/services/owner/system_service.dart';
import '../base_controller.dart';

class SystemController extends BaseController {
  final SystemService _service;
  SystemController(this._service);

  List<Group> groups = [];
  List<User> users = [];

  Map<int, List<User>> groupMembers = {};
  Set<int> loadingGroups = {};

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        _service.getGroups(),
        _service.getUsers(),
      ]);

      groups = results[0] as List<Group>;
      users = results[1] as List<User>;
    } catch (e) {
      debugPrint('Lỗi nghiêm trọng khi fetch data hệ thống: $e');
      rethrow;
    }
  }

  Future<void> loadSystemOverview() async {
    await loadData(_fetchData);
  }

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

  Future<void> addUserToGroup(
      {required String userId, required int groupId}) async {
    await _performAction(() async {
      await _service.addUserToGroup(userId, groupId);
      await loadMembersForGroup(groupId, forceReload: true);
    });
  }

  Future<void> removeUserFromGroup(
      {required String userId, required int groupId}) async {
    await _performAction(() async {
      await _service.removeUserFromGroup(userId, groupId);
      await loadMembersForGroup(groupId, forceReload: true);
    });
  }

  Future<void> loadMembersForGroup(int groupId,
      {bool forceReload = false}) async {
    if (groupMembers.containsKey(groupId) && !forceReload) return;

    loadingGroups.add(groupId);
    notifyListeners();

    try {
      final members = await _service.getMembersOfGroup(groupId);
      groupMembers[groupId] = members;
    } catch (e) {
      debugPrint('Lỗi khi tải thành viên cho nhóm $groupId: $e');
      groupMembers[groupId] = [];
    } finally {
      loadingGroups.remove(groupId);
      notifyListeners();
    }
  }
}
