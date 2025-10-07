import 'package:extractorapplication/supabase/supabase_client.dart';

import '../../Model/expense_model.dart';

class OwnerFinancialService {
  final _supabase = SupabaseManager.client;
  bool isLoading = false;
  Future<double> getTotalRevenue() async {
    try {
      isLoading = true;
      final response = await _supabase.from('expenses').select('*');
      final data = response as List;
      return data.fold<double>(
          0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }

  Future<List<Expense>> getMonthlyReport() async {
    try {
      isLoading = true;
      final respose = await _supabase.from('expenses').select('*');
      final data = respose as List;
      return data.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }
}

class RevenueReportService {
  final _client = SupabaseManager.client;
  bool isLoading = false;

  Future<List<Expense>> getRevenueReport() async {
    try {
      isLoading = true;
      final response = await _client.from('revenue_report').select().order('month');
      return response.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      isLoading = false;
      throw Exception('have a bug: $e');
    }
  }
}