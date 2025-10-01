import 'package:extractorapplication/supabase/supabase_client.dart';

class OwnerFinancialService {
  final supabase = SupabaseManager();
  Future<double> getTotalRevenue() async {
    final response = await supabase.from('expense').select('amount');

    return response.fold(0.0, (sum, item) =>sum +(item['amount'] as double));
  }
}