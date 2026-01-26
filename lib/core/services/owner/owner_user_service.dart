import 'package:extractorapplication/Model/user_model.dart';
import 'package:flutter/material.dart';

import '../db_help.dart';

///lop truy cap du lieu, giao tiep voi nguon du lieu (supabase)
///su dung supabase
///lop nay se dung de dua du lieu tu controller len db
///
class OwnerUserService {
  final DatabaseService db;
  OwnerUserService(this.db);

  Future<int> getUserCount() async {
    try {
      final response = await db.getAll('users');
      return response.length;
    } catch (e) {
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
      return response.map((e) => e['title'] as String).toList();
    } catch (e) {
      throw Exception('Error fetching recent activities: $e');
    }
  }

  ///lay toan bo nguoi dung
  Future<List<User>> getAllUsers() async {
    try {
      final response = await db.getAll('users');
      debugPrint('raw user data: $response');
      return response.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      // print('raw user data: $e');
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
        orderBy: 'created_at',
        ascending: false,
        limit: 100,
      );
      return response.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching users by role: $e');
    }
  }

  ///cap nhat vai tro nguoi dung
  Future<User> updateUserRole(String userId, String newRole) async {
    try {
      final responseData = await db.update('users', userId, {'role': newRole});
      return User.fromJson(responseData);
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }

  //Cap nhat nguoi dung
  Future<User> updateUser(User user) async {
    try {
      final responseData = await db.update('users', user.id, user.toJson());
      return User.fromJson(responseData);
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
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      final responseData = await db.insert('users', userData);
      return User.fromJson(responseData);
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }
}
