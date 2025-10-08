import '../../supabase/supabase_client.dart';

class OwnerSystemService {
  final supabase = SupabaseManager.client;
  bool isLoading = false;
  Future<String> getSystemHealth() async {
    try {
      isLoading = true;
      return Future.delayed(
          const Duration(microseconds: 500), () => 'System work find');
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }
}