import 'package:extractorapplication/supabase/supabase_client.dart';

class OwnerUserService {
  final supabase = SupabaseManager();
  Future<int> getUserCount() async {
    final response = await supabase.from('user').select();
    return response.length;
  }

  Future<List<String>> getRecentActivities() async {
    final response = await supabase.from('notifications').select('message').order('createdAt', ascending: false).limit(5);
    return response.map((e) => e['message'] as String).toList();
  }
}