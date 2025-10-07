import '../../Model/group_model.dart';
import '../../Model/user_model.dart';
import '../../supabase/supabase_client.dart';

class SystemService {
  final _supabase = SupabaseManager.client;
  bool isLoading = false;

  Future<List<Group>> getGroups() async {
    try {
      isLoading = true;
      final response = await _supabase.from('groups').select('*');
      final data = response as List;
      return data.map((e) => Group.fromJson(e)).toList();
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
}

  Future<List<User>> getUsers() async {
    try {
      isLoading = true;
      final response = await _supabase.from('users').select('*');
      final data = response as List;
      return data.map((e) => User.fromJson(e)).toList();
  } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }

  Future<void> addUserToGroup(String userId, String groupId) async {
    try {
      isLoading = true;
      await _supabase.from('user_groups').insert({
        'userId': userId,
        'groupId': groupId,
      });
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }
  Future<void> removeUserFromGroup(String userId, String groupId) async {
    try {
      isLoading = true;
      await _supabase.from('user_groups').delete().eq('user_id', userId).eq('group_id', groupId);
      } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }
}