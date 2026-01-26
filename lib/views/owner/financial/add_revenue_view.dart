import 'package:extractorapplication/Controller/owner/financial_controller.dart';
import 'package:extractorapplication/Controller/owner/system_controller.dart';
import 'package:extractorapplication/Model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRevenueView extends StatefulWidget {
  const AddRevenueView({super.key});

  @override
  State<AddRevenueView> createState() => _AddRevenueViewState();
}

class _AddRevenueViewState extends State<AddRevenueView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  int? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemController>().loadSystemOverview();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveRevenue() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final controller = context.read<FinancialController>();
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content:
              Text('Lỗi nghiêm trọng: Không tìm thấy người dùng hiện tại.'),
        ),
      );
      return;
    }

    final expenseData = {
      'user_id': userId,
      'amount': double.parse(_amountController.text),
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'group_id': _selectedGroupId,
      'created_at': _selectedDate.toIso8601String(),
    };

    final success = await controller.addRevenue(expenseData);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thêm doanh thu thành công!")),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Lưu thất bại. Vui lòng thử lại!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final financialController = context.watch<FinancialController>();
    final systemController = context.watch<SystemController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm doanh thu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập số tiền thu được',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Vui lòng nhập một số hợp lệ';
                  }
                  if (amount <= 0) {
                    return 'Số tiền phải lớn hơn 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedGroupId,
                decoration: const InputDecoration(
                  labelText: 'Nhóm',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group_work_outlined),
                ),
                hint: const Text('Chọn nhóm liên quan'),
                items: systemController.isLoading
                    ? []
                    : systemController.groups.map((Group group) {
                        return DropdownMenuItem<int>(
                          value: group.id,
                          child: Text(group.name),
                        );
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Vui lòng chọn một nhóm' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                hint: const Text('Chọn một danh mục'),
                items: const [
                  DropdownMenuItem(
                      value: 'Bán tại chỗ', child: Text('Bán tại chỗ')),
                  DropdownMenuItem(value: 'Mang đi', child: Text('Mang đi')),
                  DropdownMenuItem(
                      value: 'Giao hàng', child: Text('Giao hàng')),
                  DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng chọn một danh mục'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả (Ghi chú)',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả cho khoản thu',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Chọn ngày'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      financialController.isLoading ? null : _saveRevenue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: financialController.isLoading
                      ? const SizedBox.shrink()
                      : const Icon(Icons.save),
                  label: financialController.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Lưu Doanh Thu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
