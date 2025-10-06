import 'package:extractorapplication/Model/user_model.dart';
import 'package:extractorapplication/services/owner/owner_user_service.dart';

class UserManagementController {
  final _service = OwnerUserService();

  List<User> users = [];
  bool isLoading = false;

  Future<void> loadUsers({String? role}) async {
    try {
      isLoading = true;

      if (role != null) {
        users = await _service.getUsersByRole(role);
      } else {
        users = await _service.getAllUsers();
      }

      isLoading = false;
    } catch (e) {
      isLoading = false;
      // print('Error loading users: $json');
      throw Exception('Error loading users: $e');
    }
  }


  Future<void> changeUserRole(String userId, String newRole) async {
    try {
      isLoading = true;

      await _service.updateUserRole(userId, newRole);
      await loadUsers();
    }
    catch (e) {
      isLoading = false;
      throw Exception('Error changing user role: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading = true;
      await _service.deleteUser(userId);
      await loadUsers();
    } catch (e) {
      isLoading = false;
      throw Exception('Error deleting user: $e');
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      isLoading = true;
      await _service.createUser(userData);
      await loadUsers();
    }
    catch (e) {
      isLoading = false;
      throw Exception('Error creating user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      isLoading = true;
      await _service.updateUser(user);
      await loadUsers();
    } catch (e) {
      isLoading = false;
      throw Exception('Error updating user: $e');
    }
  }
}
