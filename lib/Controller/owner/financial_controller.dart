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

  Future<bool> _performAction(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('FinancialController Error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> addRevenue(Map<String, dynamic> expenseData) async {
    await _performAction(() async {
      final newExpense = await _service.createExpense(expenseData);
      // Add to list and recalculate total revenue to update UI instantly
      monthlyReport.insert(0, newExpense);
      totalRevenue += newExpense.amount;
      notifyListeners();
    });
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
