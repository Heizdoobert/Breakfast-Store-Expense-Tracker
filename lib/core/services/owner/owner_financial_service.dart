import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

import '../../../Model/expense_model.dart';

class OwnerFinancialService {
  final DatabaseService db;
  OwnerFinancialService(this.db);
  
  Future<double> getTotalRevenue() async {
    try {
      return await db.getAggregate(table: 'expenses', column: 'amount');
    } catch (e) {
      throw ServerException('Error call service get total: $e');
    }
  }

  Future<List<Expense>> getMonthlyReport() async {
    try {
      final response = await db.getAll('expenses');
      return response.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Error call report month: $e');
    }
  }
}

class RevenueReportService {
  final DatabaseService db;
  RevenueReportService(this.db);

  Future<List<Expense>> getRevenueReport() async {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).toIso8601String();
      final response = await db.supabase.from('expenses').select().gte('created_at', firstDayOfMonth).lte('created_at', lastDayOfMonth).order('created_at');
      return response.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      throw Exception('have a bug: $e');
    }
  }
}