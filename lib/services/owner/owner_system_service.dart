import 'package:extractorapplication/supabase/supabase_client.dart';

class OwnerSystemService {
  final supabase = SupabaseManager();
  Future<String> getSystemHealth() async {
    return Future.delayed(const Duration(microseconds: 500), () => 'System work find');
  }
}