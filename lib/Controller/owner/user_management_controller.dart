import 'package:extractorapplication/Model/user_model.dart';
import 'package:extractorapplication/services/owner/owner_user_service.dart';

class UserManagementController {
  final _service = OwnerUserService();

  List<User> users = [];
  bool isLoading = false;

  Future<void> loadUsers({String? role}) async {
    isLoading = true;

    if (role != null) {
      users = await _service.getUsersByRole(role);
    } else {
      users = await _service.getAllUsers();
    }

    isLoading = false;
  }


  Future<void> changeUserRole(String userId, String newRole) async {
    await _service.updateUserRole(userId, newRole);
    await loadUsers();
  }

  Future<void> deleteUser(String userId) async {
    await _service.deleteUser(userId);
    await loadUsers();
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    await _service.createUser(userData);
    await loadUsers();
  }
}
