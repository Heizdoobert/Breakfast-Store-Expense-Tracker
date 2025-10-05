import 'package:extractorapplication/Model/group_model.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/user_model.dart';
import '../../services/owner/system_service.dart';

class SystemController extends ChangeNotifier {
  final _service = SystemService();

  List<Group> groups = [];
  List<User> users = [];
  bool isLoading = false;

  Future<void> loadSystemOverview() async{
    isLoading = true;
    notifyListeners();

    try{
      groups = await _service.getGroups();
      users = await _service.getUsers();
    } catch (e) {
      debugPrint('❌ Error loading system overview: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(String userId, String groupId) async {
    try {
      await _service.addUser(userId, groupId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding user: $e');
    }
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    try {
      await _service.removeUserFromGroup(userId, groupId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error removing user from group: $e');
    }
  }
}