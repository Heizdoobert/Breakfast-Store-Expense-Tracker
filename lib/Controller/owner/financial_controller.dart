import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/expense_model.dart';
import '../../core/services/owner/owner_financial_service.dart';

///lop controller thuc hien xu ly logic
///goi service tuong ung de xu ly du lieu ben tren va ben duoi
///lop nay giup toi uu viec xu ly thay vi lap lai qua trinh goi nhieu lan tu cac lop
class FinancialController extends BaseController {
  final OwnerFinancialService _service;
  //nhan service thong quan constructor
  FinancialController(this._service);
  double totalRevenue = 0.0;
  List<Expense> monthlyReport = [];

  //goi tai logic rieng
  Future<void> _fetchData() async {
    final revenue = await _service.getTotalRevenue();
    final report = await _service.getMonthlyReport();

    totalRevenue = revenue;
    monthlyReport = report;
  }

  Future<void> loadFinancialData() async {
    await loadData(_fetchData);
  }

  Future<T?> _performAction<T>(Future<T> Function() action) async {
    setLoading(true);
    try {
      final result = await action();
      return result;
    } catch (e) {
      debugPrint('FinancialController Error: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> addRevenue(Map<String, dynamic> expenseData) async {
    return await _performAction(() async {
          final newExpense = await _service.createExpense(expenseData);

          monthlyReport.insert(0, newExpense);
          totalRevenue += newExpense.amount;
          notifyListeners();

          return true;
        }) ??
        false;
  }
}

class RevenueReportController extends BaseController {
  final RevenueReportService _service;
  RevenueReportController(this._service);
  List<Expense> monthlyRevenue = [];

  Future<void> _fetchData() async {
    final revenue = await _service.getRevenueReport();
    monthlyRevenue = revenue;
  }

  Future<void> loadRevenueReport() async {
    await loadData(_fetchData);
  }
}
