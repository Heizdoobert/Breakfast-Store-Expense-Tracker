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
      throw Exception('Loi khi lay danh sach nhom: $e');
    }
}

  Future<List<User>> getUsers() async {
    try {
      final response = await db.getAll('users');
      return response.map((e) =>User.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Loi khi lay danh sach nguoi dung: $e');
    }
  }

  Future<void> addUserToGroup(String userId, String groupId) async {
    try {
      await db.insert('group_members', {'user_id': userId, 'group_id': groupId});
    } catch (e) {
      throw Exception('Loi khi them nguoi dung vao nhom: $e');
    }
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    try {
      await db.delete('group_members', {'user_id': userId, 'group_id': groupId});
      } catch (e) {
      throw Exception('loi khi xoa nguoi dung khoi nhom: $e');
    }
  }
}