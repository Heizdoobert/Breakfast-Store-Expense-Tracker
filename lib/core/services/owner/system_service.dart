import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

import '../../../Model/group_model.dart';
import '../../../Model/user_model.dart';

///lop truy cap du lieu, giao tiep voi nguon du leiu (supabase)
///su dung supabase
///lop nay se dung de dua du lieu tu controller len db
///
class SystemService {
  final DatabaseService db;
  SystemService(this.db);

  Future<List<Group>> getGroups() async {
    try {
      final response = await db.getAll('groups');
      return response.map((e) => Group.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Loi khi lay danh sach nhom: $e');
    }
}

  Future<List<User>> getUsers() async {
    try {
      final response  = await db.getAll('users');
      return response.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Loi khi lay danh sach nguoi dung: $e');
    }
  }

  Future<List<User>> getMembersOfGroup(String groupId) async {
    try {
      final response = await db.supabase
          .from('group_members')
          .select('users(*)') // Lấy tất cả thông tin của user liên quan
          .eq('group_id', groupId);

      final userMaps = response.map((e) => e['users'] as Map<String, dynamic>).toList();
      return userMaps.map((userMap) => User.fromJson(userMap)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy thành viên của nhóm: $e');
    }
  }

  Future<void> addUserToGroup(String userId, String groupId) async {
    try {
      await db.insert('group_members', {'user_id': userId, 'group_id': groupId});
    } catch (e) {
      throw ServerException('Loi khi them nguoi dung vao nhom: $e');
    }
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    try {
      await db.deleteWhere('group_members', {'user_id': userId, 'group_id': groupId});
      } catch (e) {
      throw ServerException('loi khi xoa nguoi dung khoi nhom: $e');
    }
  }
}