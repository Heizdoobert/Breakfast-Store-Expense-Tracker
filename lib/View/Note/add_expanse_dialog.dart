// daily_expense_card.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:extractorapplication/Controller/ExpenseController.dart';
import 'package:intl/intl.dart';

class DailyExpenseCard extends StatefulWidget {
  final ExpenseController controller;
  final int groupId;
  final int userId;

  const DailyExpenseCard({
    super.key,
    required this.controller,
    required this.groupId,
    required this.userId,
  });

  @override
  State<DailyExpenseCard> createState() => _DailyExpenseCardState();
}

class _DailyExpenseCardState extends State<DailyExpenseCard> {
  double _total = 0;
  List<Map<String, dynamic>> _items = [];
  final _currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  Future<void> _reloadData() async {
    try {
      // 1. Lấy tổng và chi tiết
      final total = await widget.controller.getTodayTotalExpense(
        groupId: widget.groupId,
      );
      final details = await widget.controller.getTodayExpenseDetails(
        groupId: widget.groupId,
      );

      if (!mounted) return;
      setState(() {
        _total = total;
        _items = details;
      });
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _addExpenseDialog() async {
    final descCtl = TextEditingController();
    final amtCtl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Thêm chi tiêu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mô tả
                  TextField(
                    controller: descCtl,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Số tiền
                  TextField(
                    controller: amtCtl,
                    decoration: InputDecoration(
                      labelText: 'Số tiền',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Hủy'),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final desc = descCtl.text.trim();
                  final amt = double.tryParse(amtCtl.text.trim()) ?? 0;
                  if (desc.isEmpty || amt <= 0) return;

                  await widget.controller.addExpense(
                    groupId: widget.groupId,
                    userId: widget.userId,
                    amount: amt,
                    description: desc,
                  );

                  Navigator.pop(context);
                  await _reloadData();
                },
                icon: const Icon(Icons.save),
                label: const Text('Lưu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "💰 Chi tiêu hôm nay",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tổng: ${_currency.format(_total)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        if (_items.isEmpty)
          const Text(
            'Chưa có chi tiêu nào hôm nay.',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 8),
              itemBuilder: (_, i) {
                final e = _items[i];
                final amount = (e['amount'] as num).toDouble();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e['description'],
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _currency.format(amount),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addExpenseDialog,
                icon: const Icon(Icons.add),
                label: const Text('Thêm chi tiêu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _reloadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Làm mới'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                side: BorderSide(color: Colors.blue.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}