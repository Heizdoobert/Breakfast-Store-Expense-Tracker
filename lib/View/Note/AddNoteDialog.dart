import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddNoteDialog({super.key, required this.onSave});

  // Phương thức show được chuyển vào đây
  static void show(BuildContext context, {required Function(Map<String, dynamic>) onSave}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: AddNoteDialog(onSave: onSave),
          ),
        );
      },
    );
  }

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Công việc';
  String _selectedPriority = 'Bình thường';

  // Danh sách phân loại tạm thời, sau sẽ thay bằng dữ liệu từ DB
  final List<String> _categories = [
    'Công việc',
    'Cá nhân',
    'Mua sắm',
    'Tài chính',
    'Nhân sự',
    'Kho hàng',
    'Khác'
  ];

  final List<String> _priorities = [
    'Rất quan trọng',
    'Quan trọng',
    'Bình thường',
    'Không quan trọng'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với nút đóng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thêm ghi chú mới',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Form nhập liệu
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Tiêu đề',
                        labelStyle: const TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tiêu đề';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Nội dung',
                        labelStyle: const TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nội dung';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Dropdown phân loại
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                          elevation: 8,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                          items: _categories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(value),
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Dropdown độ ưu tiên
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPriority,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                          elevation: 8,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPriority = newValue!;
                            });
                          },
                          items: _priorities.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    _getPriorityIcon(value),
                                    color: _getPriorityColor(value),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Nút lưu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave({
                    'title': _titleController.text,
                    'content': _contentController.text,
                    'category': _selectedCategory,
                    'priority': _selectedPriority,
                    'created_at': DateTime.now().toString(),
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Lưu ghi chú',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm lấy icon cho phân loại
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Công việc':
        return Icons.work_rounded;
      case 'Cá nhân':
        return Icons.person_rounded;
      case 'Mua sắm':
        return Icons.shopping_cart_rounded;
      case 'Tài chính':
        return Icons.attach_money_rounded;
      case 'Nhân sự':
        return Icons.people_rounded;
      case 'Kho hàng':
        return Icons.inventory_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  // Hàm lấy icon cho độ ưu tiên
  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Rất quan trọng':
        return Icons.error_rounded;
      case 'Quan trọng':
        return Icons.warning_rounded;
      case 'Bình thường':
        return Icons.info_rounded;
      case 'Không quan trọng':
        return Icons.low_priority_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  // Hàm lấy màu cho độ ưu tiên
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Rất quan trọng':
        return Colors.red;
      case 'Quan trọng':
        return Colors.orange;
      case 'Bình thường':
        return Colors.blue;
      case 'Không quan trọng':
        return Colors.grey;
      default:
        return Colors.teal;
    }
  }
}