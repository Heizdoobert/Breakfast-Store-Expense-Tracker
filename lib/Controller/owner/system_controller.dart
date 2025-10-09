import 'package:extractorapplication/Model/group_model.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/user_model.dart';
import '../../core/services/owner/system_service.dart';
import '../base_controller.dart';

///controller su dung provider de lang nghe
///load system mot lan ma khong can load lai
///CRUD system
class SystemController extends BaseController {
  final SystemService _service;
  SystemController(this._service);

  List<Group> groups = [];
  List<User> users = [];

  Map<String, List<User>> groupMembers = {};
  Set<String> loadingGroups = {};

  Future<void> _fetchData() async {
    final results = await Future.wait([
      _service.getGroups(),
      _service.getUsers(),
    ]);
    groups = results[0] as List<Group>;
    users = results[1] as List<User>;
  }

  Future<void> loadSystemOverview() async {
    await loadData(_fetchData);
  }

  //check tinh dung dan 1 lan khong can code lai
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

  Future<void> addUserToGroup({required String userId, required String groupId}) async {
    await _performAction(() async {
      await _service.addUserToGroup(userId, groupId);
      await loadSystemOverview();
    });
  }

  Future<void> removeUserFromGroup({required String userId,required String groupId}) async {
    await _performAction(() async {
      await _service.removeUserFromGroup(userId, groupId);
      await loadSystemOverview();
    });
  }

  Future<void> loadMembersForGroup(String groupId) async {
    if (groupMembers.containsKey(groupId)) return;
    loadingGroups.add(groupId);
    notifyListeners();

    try {
      final members = await _service.getMembersOfGroup(groupId);
      groupMembers[groupId] = members;
    } catch (e) {
      debugPrint('Error loading members for group $groupId: $e');
      groupMembers[groupId] = [];
    } finally {
      loadingGroups.remove(groupId);
      notifyListeners();
    }
  }
}
