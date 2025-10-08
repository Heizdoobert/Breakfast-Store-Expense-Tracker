import 'package:extractorapplication/Controller/base_controller.dart';
import '../../Model/expense_model.dart';
import '../../core/services/owner/owner_financial_service.dart';

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
    //service tra ve tranh loi runtime
    monthlyReport = report.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> loadFinancialData() async {
    await loadData(_fetchData);
  }
}


class RevenueReportController extends BaseController {
  final RevenueReportService _service;
  RevenueReportController(this._service);
  List<Expense> monthlyRevenue = [];

  Future<void> _fetchData() async {
    final revenue = await _service.getRevenueReport();
    monthlyRevenue = revenue.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> loadRevenueReport() async {
    await loadData(_fetchData);
  }
}
