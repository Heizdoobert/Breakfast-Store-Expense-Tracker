// Path: lib/core/services/owner/system_service.dart

import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';
import 'package:flutter/material.dart';

import '../../../Model/group_model.dart';
import '../../../Model/user_model.dart';

/// lop truy cap du lieu, giao tiep voi nguon du leiu (supabase)
/// su dung supabase
/// lop nay se dung de dua du lieu tu controller len db
///
class SystemService {
  final DatabaseService db;
  SystemService(this.db);

  // === SỬA LỖI 1: Sửa kiểu trả về từ List<User> thành List<Group> ===
  Future<List<Group>> getGroups() async {
    try {
      final response = await db.getAll('groups');
      // Dữ liệu từ bảng 'groups' phải được map thành đối tượng Group
      return response.map((e) => Group.fromJson(e)).toList();
    } catch (e) {
      // In lỗi ra console để debug dễ hơn
      debugPrint('Lỗi nghiêm trọng khi lấy danh sách nhóm: $e');
      throw ServerException('Lỗi khi lấy danh sách nhóm: $e');
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await db.getAll('users');
      return response.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Lỗi nghiêm trọng khi lấy danh sách người dùng: $e');
      throw ServerException('Lỗi khi lấy danh sách người dùng: $e');
    }
  }

  Future<List<User>> getMembersOfGroup(int groupId) async {
    try {
      final response = await db.supabase
          .from('group_members')
          .select('users!inner(*)')
          .eq('group_id', groupId);

      if (response.isEmpty) {
        return [];
      }

      final userMaps = response
          .map((item) => item['users'] as Map<String, dynamic>)
          .toList();
      return userMaps.map((userMap) => User.fromJson(userMap)).toList();
    } catch (e) {
      debugPrint('Lỗi nghiêm trọng khi lấy thành viên của nhóm $groupId: $e');
      throw Exception('Lỗi khi lấy thành viên của nhóm: $e');
    }
  }

  Future<void> addUserToGroup(String userId, int groupId) async {
    try {
      await db
          .insert('group_members', {'user_id': userId, 'group_id': groupId});
    } catch (e) {
      debugPrint(
          'Lỗi nghiêm trọng khi thêm user $userId vào nhóm $groupId: $e');
      throw ServerException('Lỗi khi thêm người dùng vào nhóm: $e');
    }
  }

  Future<void> removeUserFromGroup(String userId, int groupId) async {
    try {
      await db.deleteWhere(
          'group_members', {'user_id': userId, 'group_id': groupId});
    } catch (e) {
      debugPrint(
          'Lỗi nghiêm trọng khi xóa user $userId khỏi nhóm $groupId: $e');
      throw ServerException('Lỗi khi xóa người dùng khỏi nhóm: $e');
    }
  }
}
