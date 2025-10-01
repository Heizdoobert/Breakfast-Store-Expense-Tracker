import 'package:extractorapplication/supabase/supabase_client.dart';

class OwnerFinancialService {
  final supabase = SupabaseManager.client;
  Future<double> getTotalRevenue() async {
    final response = await supabase.from('expenses').select('amount');

    return response.fold<double>(0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
  }
}