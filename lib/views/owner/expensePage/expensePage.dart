import 'package:flutter/material.dart';
import 'package:extractorapplication/Controller/expense_controller.dart';
import 'package:extractorapplication/Model/Expense.dart';
import 'package:extractorapplication/services/saveSession.dart';

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
  Future<void> initState() async {
    super.initState();
    _loadExpenses();
    final userId = await UserStorage.getUserId();
    _firstExpense = await _controller.getFirstExpenseByUser(userId!);
  }

  Future<void> _loadExpenses() async {
    final userId = await UserStorage.getUserId();
    print('[ExpensePage] userId hiện tại: $userId');

    if (userId != null) {
      final List<Expense> data = await _controller.getExpensesByUser(userId);
      print('[ExpensePage] Số lượng chi phí: ${data.length}');
      setState(() => _expenses = data);
    }
  }


  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadExpenses,
      child: ListView(
        children: [
          _emptyExpenseCard(
            title: _firstExpense?.title,
            category: _firstExpense?.category,
            amount: _firstExpense?.amount,
            createdAt: _firstExpense?.createdAt,
          ),
          const Divider(),
          ..._expenses.map((e) => _expenseCard(e)).toList(),
        ],
      ),
    );
  }

  Widget _expenseCard(Expense expense) {
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
              Text('Ngày tạo: ${expense.createdAt?.toLocal().toString().split(" ")[0] ?? "(chưa có)"}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyExpenseCard({
    String? title,
    String? category,
    double? amount,
    DateTime? createdAt,
  }) {
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
              Text('Tiêu đề: ${title ?? "(chưa có)"}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
              Text('Danh mục: ${category ?? "(chưa có)"}',
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 8),
              Text('Số tiền: ${amount?.toStringAsFixed(0) ?? "0"}đ',
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 8),
              Text('Ngày tạo: ${createdAt != null ? createdAt.toLocal().toString().split(" ")[0] : "(chưa có)"}',
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}