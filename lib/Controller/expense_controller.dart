import 'package:extractorapplication/Model/Expense.dart';

import '../services/db_help.dart';

class ExpenseController {
  // Sử dụng DatabaseHelper đã định nghĩa
  final db = DatabaseHelper();

  //expense
  Future<List<Expense>> getAllExpenses(int userId) async {
    print(
      '[ExpenseController getAllExpenses] Bắt đầu lấy tất cả chi phí cho userId: $userId',
    );
    try {
      final data = await db.query(
        'expenses',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController getAllExpenses] Số lượng chi phí tìm thấy: ${data.length}',
      );
      return data.map((e) => Expense.fromMap(e)).toList();
    } catch (e, stackTrace) {
      print(
        '[ExpenseController getAllExpenses] Lỗi khi lấy tất cả chi phí: $e',
      );
      print('[ExpenseController getAllExpenses] Stack trace: $stackTrace');
      return []; // Trả về danh sách rỗng khi có lỗi
    }
  }

  Future<int> addExpense(Expense expense) async {
    print(
      '[ExpenseController addExpense] Bắt đầu thêm chi phí: ${expense.toMap()}',
    );
    try {
      final id = await db.insert('expenses', expense.toMap());
      print('[ExpenseController addExpense] Chi phí đã được thêm với ID: $id');
      return id;
    } catch (e, stackTrace) {
      print('[ExpenseController addExpense] Lỗi khi thêm chi phí: $e');
      print('[ExpenseController addExpense] Stack trace: $stackTrace');
      return -1;
    }
  }

  Future<int> updateExpense(Expense expense) async {
    print(
      '[ExpenseController updateExpense] Bắt đầu cập nhật chi phí với ID: ${expense.expenseId}, dữ liệu: ${expense.toMap()}',
    );
    try {
      final rowsAffected = await db.update(
        'expenses',
        expense.toMap(),
        where: 'expenseId = ?',
        whereArgs: [?expense.expenseId],
      );
      print(
        '[ExpenseController updateExpense] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController updateExpense] Lỗi khi cập nhật chi phí: $e');
      print('[ExpenseController updateExpense] Stack trace: $stackTrace');
      return -1; // Trả về -1 hoặc throw exception
    }
  }

  Future<int> deleteExpense(int expenseId) async {
    print(
      '[ExpenseController deleteExpense] Bắt đầu xóa chi phí với ID: $expenseId',
    );
    try {
      final rowsAffected = await db.delete(
        'expenses',
        where: 'expenseId = ?',
        whereArgs: [expenseId],
      );
      print(
        '[ExpenseController deleteExpense] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController deleteExpense] Lỗi khi xóa chi phí: $e');
      print('[ExpenseController deleteExpense] Stack trace: $stackTrace');
      return -1; // Trả về -1 hoặc throw exception
    }
  }

  Future<List<Expense>> getExpensesByUser(int userId) async {
    print(
      '[ExpenseController getExpensesByUser] Bắt đầu lấy chi phí cho userId: $userId',
    );
    try {
      final raw = await db.query(
        'expenses',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController getExpensesByUser] Số lượng chi phí tìm thấy cho userId $userId: ${raw.length}',
      );
      return raw.map((e) => Expense.fromMap(e)).toList();
    } catch (e, stackTrace) {
      print(
        '[ExpenseController getExpensesByUser] Lỗi khi lấy chi phí cho userId $userId: $e',
      );
      print('[ExpenseController getExpensesByUser] Stack trace: $stackTrace');
      return [];
    }
  }

  Future<Expense?> getFirstExpenseByUser(int userId) async {
    print(
      '[ExpenseController getFirstExpenseByUser] Bắt đầu lấy chi phí đầu tiên cho userId: $userId',
    );
    try {
      final raw = await db.query(
        'expenses',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      if (raw.isNotEmpty) {
        final expense = Expense.fromMap(raw.first);
        print(
          '[ExpenseController getFirstExpenseByUser] Tìm thấy chi phí đầu tiên: ${expense.toMap()}',
        );
        return expense;
      }
      print(
        '[ExpenseController getFirstExpenseByUser] Không tìm thấy chi phí đầu tiên cho userId: $userId',
      );
      return null;
    } catch (e, stackTrace) {
      print(
        '[ExpenseController getFirstExpenseByUser] Lỗi khi lấy chi phí đầu tiên cho userId $userId: $e',
      );
      print(
        '[ExpenseController getFirstExpenseByUser] Stack trace: $stackTrace',
      );
      return null;
    }
  }

  //budget
  Future<int> getBudget(int userId) async {
    print('[ExpenseController getBudget] Lấy ngân sách cho userId: $userId');
    try {
      final data = await db.query(
        'budget',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      if (data.isNotEmpty) {
        final budget = data.first['budget'] as int;
        print('[ExpenseController getBudget] Ngân sách tìm thấy: $budget');
        return budget;
      }
      print(
        '[ExpenseController getBudget] Không tìm thấy ngân sách cho userId: $userId. Trả về 0.',
      );
      return 0;
    } catch (e, stackTrace) {
      print(
        '[ExpenseController getBudget] Lỗi khi lấy ngân sách cho userId $userId: $e',
      );
      print('[ExpenseController getBudget] Stack trace: $stackTrace');
      return 0; // Trả về 0 khi có lỗi
    }
  }

  Future<int> addBudget(int userId, int budget) async {
    print(
      '[ExpenseController addBudget] Thêm ngân sách $budget cho userId: $userId',
    );
    try {
      final id = await db.insert('budget', {
        'userId': userId,
        'budget': budget,
      });
      print('[ExpenseController addBudget] Ngân sách đã được thêm với ID: $id');
      return id;
    } catch (e, stackTrace) {
      print('[ExpenseController addBudget] Lỗi khi thêm ngân sách: $e');
      print('[ExpenseController addBudget] Stack trace: $stackTrace');
      return -1;
    }
  }

  Future<int> updateBudget(int userId, int budget) async {
    print(
      '[ExpenseController updateBudget] Cập nhật ngân sách thành $budget cho userId: $userId',
    );
    try {
      final rowsAffected = await db.update(
        'budget',
        {'budget': budget},
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController updateBudget] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController updateBudget] Lỗi khi cập nhật ngân sách: $e');
      print('[ExpenseController updateBudget] Stack trace: $stackTrace');
      return -1;
    }
  }

  Future<int> deleteBudget(int userId) async {
    print('[ExpenseController deleteBudget] Xóa ngân sách cho userId: $userId');
    try {
      final rowsAffected = await db.delete(
        'budget',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController deleteBudget] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController deleteBudget] Lỗi khi xóa ngân sách: $e');
      print('[ExpenseController deleteBudget] Stack trace: $stackTrace');
      return -1;
    }
  }

  //debt
  Future<int> getDebt(int userId) async {
    print('[ExpenseController getDebt] Lấy nợ cho userId: $userId');
    try {
      final data = await db.query(
        'debt',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      if (data.isNotEmpty) {
        final debt = data.first['debt'] as int;
        print('[ExpenseController getDebt] Số nợ tìm thấy: $debt');
        return debt;
      }
      print(
        '[ExpenseController getDebt] Không tìm thấy nợ cho userId: $userId. Trả về 0.',
      );
      return 0;
    } catch (e, stackTrace) {
      print(
        '[ExpenseController getDebt] Lỗi khi lấy nợ cho userId $userId: $e',
      );
      print('[ExpenseController getDebt] Stack trace: $stackTrace');
      return 0; // Trả về 0 khi có lỗi
    }
  }

  Future<int> addDebt(int userId, int debt) async {
    print('[ExpenseController addDebt] Thêm nợ $debt cho userId: $userId');
    try {
      final id = await db.insert('debt', {'userId': userId, 'debt': debt});
      print('[ExpenseController addDebt] Nợ đã được thêm với ID: $id');
      return id;
    } catch (e, stackTrace) {
      print('[ExpenseController addDebt] Lỗi khi thêm nợ: $e');
      print('[ExpenseController addDebt] Stack trace: $stackTrace');
      return -1;
    }
  }

  Future<int> updateDebt(int userId, int debt) async {
    print(
      '[ExpenseController updateDebt] Cập nhật nợ thành $debt cho userId: $userId',
    );
    try {
      final rowsAffected = await db.update(
        'debt',
        {'debt': debt},
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController updateDebt] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController updateDebt] Lỗi khi cập nhật nợ: $e');
      print('[ExpenseController updateDebt] Stack trace: $stackTrace');
      return -1;
    }
  }

  Future<int> deleteDebt(int userId) async {
    print('[ExpenseController deleteDebt] Xóa nợ cho userId: $userId');
    try {
      final rowsAffected = await db.delete(
        'debt',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print(
        '[ExpenseController deleteDebt] Số dòng bị ảnh hưởng: $rowsAffected',
      );
      return rowsAffected;
    } catch (e, stackTrace) {
      print('[ExpenseController deleteDebt] Lỗi khi xóa nợ: $e');
      print('[ExpenseController deleteDebt] Stack trace: $stackTrace');
      return -1;
    }
  }
}
