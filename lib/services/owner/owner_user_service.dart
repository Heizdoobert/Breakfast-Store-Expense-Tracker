import 'package:extractorapplication/Model/user_model.dart';

import '../db_help.dart';

class OwnerUserService {
  final db = DatabaseService();

  Future<int> getUserCount() async {
    try {
      final response = await db.getAll('users');
      return response.length;
    }catch  (e) {
      throw Exception('Error fetching user count: $e');
    }
  }


  Future<List<String>> getRecentActivities() async {
    try {
      final response = await db.queryBuilder(
        table: 'notes',
        column: 'title',
        value: '',
        orderBy: 'id',
        ascending: false,
        limit: 5,
      );
      return response.map((e) => e['message'] as String).toList();
    }
    catch (e) {
      throw Exception('Error fetching recent activities: $e');
    }
  }

  ///lay toan bo nguoi dung
  Future<List<User>> getAllUsers() async {
    try {
      final response = await db.getAll('users');
      return response.map((e) => User.fromJson(e)).toList();
    }
    catch (e) {
      print('raw user data: $e');
      throw Exception('Error fetching all users: $e');
    }
  }

  ///lay nguoi dung theo vai tro
  Future<List<User>> getUsersByRole(String role) async {
    try {
      final response = await db.queryBuilder(
        table: 'users',
        column: 'role',
        value: role,
        orderBy: 'createdAt',
        ascending: false,
        limit: 100,
      );
      return response.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching users by role: $e');
    }
  }

  ///cap nhat vai tro nguoi dung
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await db.update('users', userId, {'role': newRole});
    }
    catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }

  //Cap nhat nguoi dung
  Future<void> updateUser(User user) async {
    try {
      await db.update('users', user.id, user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  ///xoa nguoi dung
  Future<void> deleteUser(String userId) async {
    try {
      await db.delete('users', userId);
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  ///them nguoi dung moi
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
    await db.insert('users', userData);
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }
}