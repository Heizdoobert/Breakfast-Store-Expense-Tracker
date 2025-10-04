import 'dart:convert';

import 'package:extractorapplication/services/owner/owner_financial_service.dart';
import 'package:flutter/material.dart';

import '../../Model/expense_model.dart';

class FinancialController extends ChangeNotifier {
  final _service = OwnerFinancialService();

  double totalRevenue = 0.0;
  List<Expense> monthlyReport = [];
  bool isLoading = false;

  Future<void> loadFinancialData() async {
    isLoading = true;
    notifyListeners();

    try {
      final revenue = await _service.getTotalRevenue();
      final report = await _service.getMonthlyReport();

      totalRevenue = revenue;
      monthlyReport = report.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('❌ Error loading financial data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


class RevenueReportController extends ChangeNotifier {
  final _service = RevenueReportService();

  List<Expense> monthlyRevenue = [];
  bool isLoading = false;

  Future<void> loadRevenueReport() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _service.getRevenueReport();
      monthlyRevenue = data.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('❌ Error loading revenue report: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
