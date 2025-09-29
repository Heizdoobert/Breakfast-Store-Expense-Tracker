import 'package:extractorapplication/Controller/expense_controller.dart';
import 'package:extractorapplication/Model/Expense.dart';
import 'package:extractorapplication/services/saveSession.dart';
import 'package:flutter/material.dart';

import '../../share/add_expense_view.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePage();
}

class _ExpensePage extends State<ExpensePage> {
  final ExpenseController _controller = ExpenseController();
  Expense? _firstExpense;
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    print('[ExpensePage initState] Bắt đầu khởi tạo.');
    _loadExpenses();
    print('[ExpensePage initState] Gọi _loadExpenses().');
    // Final userId = UserStorage.getUserId(); // Giá trị này sẽ cần await nếu là Future
    // _firstExpense = _controller.getFirstExpenseByUser(?userId) as Expense?; // Cần await và xử lý null
  }

  Future<void> _loadExpenses() async {
    print('[ExpensePage _loadExpenses] Bắt đầu tải chi phí...');
    String? userId;
    try {
      userId = (await UserStorage.getUserId()) as String?;
      print('[ExpensePage _loadExpenses] userId hiện tại: $userId');

      if (userId != null) {
        final List<Expense> data = await _controller.getExpensesByUser(
          userId as int,
        );
        print(
          '[ExpensePage _loadExpenses] Số lượng chi phí đã tải: ${data.length}',
        );
        setState(() {
          _expenses = data;
          // Nếu muốn hiển thị chi phí đầu tiên riêng biệt, cần logic để lấy nó từ data hoặc gọi hàm riêng
          // Ví dụ:
          // if (data.isNotEmpty) {
          //   _firstExpense = data.first;
          // }
        });
        print('[ExpensePage _loadExpenses] Trạng thái đã cập nhật.');
      } else {
        print('[ExpensePage _loadExpenses] Không tìm thấy userId.');
        // Có thể hiển thị thông báo lỗi hoặc reset dữ liệu nếu userId không có
        setState(() {
          _expenses = []; // Reset danh sách nếu không có userId
          _firstExpense = null;
        });
      }
    } catch (e, stackTrace) {
      print('[ExpensePage _loadExpenses] Lỗi xảy ra: $e');
      print('[ExpensePage _loadExpenses] Stack trace: $stackTrace');
      // Hiển thị lỗi cho người dùng nếu cần
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải chi phí: ${e.toString()}')),
      );
      setState(() {
        _expenses = []; // Reset danh sách khi có lỗi
        _firstExpense = null;
      });
    }
    print('[ExpensePage _loadExpenses] Hoàn tất tải chi phí.');
  }

  @override
  Widget build(BuildContext context) {
    print(
      '[ExpensePage build] Bắt đầu xây dựng giao diện. Số chi phí: ${_expenses.length}',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi phí'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
        child: ListView(
          children: [
            ..._expenses.map((e) => _expenseCard(e)).toList(),
            if (_expenses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('Không có chi phí nào được lưu trữ.'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: AddExpenseViewButton(onReturn: _loadExpenses),
    );
  }

  Widget _expenseCard(Expense expense) {
    // print('[ExpensePage _expenseCard] Đang hiển thị chi phí: ${expense.title ?? 'N/A'}'); // Có thể in ra quá nhiều nếu danh sách lớn
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tiêu đề: ${expense.title ?? "(chưa có)"}'),
              Text('Danh mục: ${expense.category ?? "(chưa có)"}'),
              Text('Số tiền: ${expense.amount?.toStringAsFixed(0) ?? "0"}đ'),
              Text(
                'Ngày tạo: ${expense.createdAt?.toLocal().toString().split(" ")[0] ?? "(chưa có)"}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho chi phí đầu tiên (hiện đang comment)
  Widget _emptyExpenseCard({
    String? title,
    String? category,
    double? amount,
    DateTime? createdAt,
  }) {
    // print('[ExpensePage _emptyExpenseCard] Đang hiển thị chi phí đầu tiên');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.orangeAccent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiêu đề: ${title ?? "(chưa có)"}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Danh mục: ${category ?? "(chưa có)"}',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Số tiền: ${amount?.toStringAsFixed(0) ?? "0"}đ',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngày tạo: ${createdAt != null ? createdAt.toLocal().toString().split(" ")[0] : "(chưa có)"}',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
