import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:extractorapplication/Model/user_model.dart';
import 'package:flutter/cupertino.dart';

import '../../core/services/owner/owner_user_service.dart';

///Controller su dung provider de lang nghe
///load user mot lan ma khong can load lai
///CRUD user
class UserManagementController extends BaseController{
  final OwnerUserService _service;
  UserManagementController(this._service);

  List<User> users = [];

  Future<void> _fetchData() async {
    users = await _service.getAllUsers();
    }

  Future<void> loadUsers() async {
    await loadData(_fetchData);
  }

  //ham tranh lap lai code
  Future<bool> _performAction(Future<void> Function() action) async {
    setLoading(true);
    try{
      await action();
      return true;
    }
    catch (e) {
      debugPrint('UserManagerController Error: $e');
      return false;
    }
    finally {
      setLoading(false);
    }
  }

  Future<void> changeUserRole(String userId, String newRole) async {
    await _performAction(() async {
      await _service.updateUserRole(userId, newRole);
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = users[index].copyWith(role: newRole);
        notifyListeners();
      }
    });
  }

  Future<void> deleteUser(String userId) async {
    //luu lai user neu loi khong xoa duoc
    final originalUser = List<User>.from(users);

    //toi uu cap nhat ui
    users.removeWhere((user) => user.id == userId);
    notifyListeners();

    final success = await _performAction(() => _service.deleteUser(userId));

    if(!success){
      users = originalUser;
      notifyListeners();
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    await _performAction(() async {
      final newUser = await _service.createUser(userData);
      users.insert(0, newUser);
      notifyListeners();
    });
  }

  Future<void> updateUser(User user) async {
    await _performAction(() async {
      final updatedUser = await _service.updateUser(user);
      final index = users.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;
        notifyListeners();
      }
    });
  }
}
