import 'package:extractorapplication/services/db_help.dart';

import '../Model/Expense.dart';

class ExpenseController {
  final db = DatabaseHelper();

  Future<List<Expense>> getAllExpenses(int userId) async {
    final data = await db.query('expenses', where: 'userId = ?', whereArgs: [userId]);
    return data.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> addExpense(Expense expense) async {
    return await db.insert('expenses', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    return await db.update('expenses', expense.toMap(), where: 'expenseId = ?', whereArgs: [?expense.expenseId]);
  }

  Future<int> deleteExpense(int expenseId) async {
    return await db.delete('expenses', where: 'expenseId = ?', whereArgs: [expenseId]);
  }

  Future<List<Expense>> getExpensesByUser(int userId) async {
    try {
      final raw = await db.query(
          'expenses', where: 'userId = ?', whereArgs: [userId]);
      return raw.map((e) => Expense.fromMap(e)).toList();
    }catch (e) {
      print(e);
      return [];
    }
  }

  Future<Expense?> getFirstExpenseByUser(int userId) async {
    try {
      final raw = await db.query(
        'expenses',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      if (raw.isNotEmpty) {
        return Expense.fromMap(raw.first);
      }
      return null;
    } catch (e) {
      print('[ExpenseController] Lỗi khi lấy chi phí đầu tiên: $e');
      return null;
    }
  }
}