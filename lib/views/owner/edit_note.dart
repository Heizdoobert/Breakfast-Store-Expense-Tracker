// G:/Project/Breakfast-Store-Expense-Tracker/lib/views/owner/note/edit_note_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Controller/owner/note_management_controller.dart';
import '../../../../Model/note_model.dart';

class EditNoteView extends StatefulWidget {
  // Widget này nhận vào đối tượng `Note` cần được chỉnh sửa.
  final Note note;

  const EditNoteView({super.key, required this.note});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  final _formKey = GlobalKey<FormState>();

  // Khai báo các TextEditingController để quản lý dữ liệu trên form.
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  // Bạn có thể thêm các controller cho category, priority nếu muốn chúng cũng có thể được sửa.

  // `initState` được gọi một lần khi widget được tạo.
  // Chúng ta dùng nó để điền dữ liệu có sẵn của `note` vào các controller.
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  // `dispose` được gọi khi widget bị hủy.
  // Rất quan trọng để giải phóng bộ nhớ cho các controller.
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Hàm này được gọi khi người dùng nhấn nút "Lưu Thay Đổi".
  void _submitChanges() async {
    // 1. Kiểm tra xem form có hợp lệ không.
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // 2. Lấy controller từ Provider.
    final controller = context.read<NoteManagementController>();

    // 3. Tạo một đối tượng `Note` mới với các thông tin đã được cập nhật từ form.
    // Sử dụng `copyWith` để giữ lại các trường không thay đổi như `id`, `userId`, `createdAt`,...
    final updatedNote = widget.note.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      // Gán lại updatedAt thành thời gian hiện tại.
      updatedAt: DateTime.now(),
    );

    // 4. Gọi hàm `updateNote` từ controller.
    final success = await controller.updateNote(updatedNote);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái `isLoading` từ controller để vô hiệu hóa nút bấm khi cần.
    final isLoading = context.watch<NoteManagementController>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa Ghi Chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  // Mặc dù title có thể null, ta vẫn có thể yêu cầu người dùng không để trống khi sửa.
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.text_fields),
                  alignLabelWithHint:
                      true, // Căn chỉnh label lên trên khi có nhiều dòng.
                ),
                maxLines: 8, // Cho phép nhập nhiều dòng hơn cho nội dung.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _submitChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      Colors.blue, // Màu sắc cho hành động cập nhật.
                ),
                icon: isLoading
                    ? Container() // Ẩn icon khi đang loading
                    : const Icon(Icons.save_as_outlined),
                label: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Lưu Thay Đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
