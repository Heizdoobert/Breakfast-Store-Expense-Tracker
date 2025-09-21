// expense_controller.dart
import 'package:flutter/foundation.dart';
import 'package:extractorapplication/Database/db_help.dart';

class ExpenseController extends ChangeNotifier {
  final DBHelper db;
  ExpenseController(this.db);

  double _todayTotal = 0;
  List<Map<String, dynamic>> _todayDetails = [];

  double get todayTotal   => _todayTotal;
  List<Map<String, dynamic>> get todayDetails => _todayDetails;

  /// Nạp lại dữ liệu hôm nay (tổng & chi tiết)
  Future<void> loadTodayExpense(int groupId) async {
    final total   = await db.getTodayTotalExpense(groupId: groupId);
    final details = await db.getTodayExpenseDetails(groupId: groupId);
    _todayTotal   = total;
    _todayDetails = details;
    notifyListeners();
  }

  Future<double> getTodayTotalExpense({required int groupId}) async {
    return await db.getTodayTotalExpense(groupId: groupId);
  }

  Future<List<Map<String, dynamic>>> getTodayExpenseDetails({required int groupId}) async {
    return await db.getTodayExpenseDetails(groupId: groupId);
  }

  /// Thêm khoản chi mới, sau đó tự động reload dữ liệu hôm nay
  Future<void> addExpense({
    required int groupId,
    required int userId,
    required double amount,
    required String description,
  }) async {
    try{
    // 1. Ghi vào DB
    // await db.insertExpense(
    //   'expenses',                       // tên table
    //   {
    //     'group_id':    groupId,        // bắt buộc có
    //     'user_id':     userId,         // bắt buộc có
    //     'amount':      amount,         // …
    //     'description': description,
    //     'created_at':  DateTime.now().toIso8601String(),
    //   },
    // );


    // 2. Cập nhật lại tổng & chi tiết hôm nay
    await loadTodayExpense(groupId);} catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('Stack: $st');
    }
  }
}