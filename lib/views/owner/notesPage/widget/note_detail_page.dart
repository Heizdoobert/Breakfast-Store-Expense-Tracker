import 'package:flutter/material.dart';
import 'package:extractorapplication/Model/Note.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  // Hàm lấy màu cho chip độ ưu tiên
  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'Cao':
        return Colors.red.shade300;
      case 'Trung bình':
        return Colors.orange.shade300;
      case 'Thấp':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  // Hàm xử lý khi nhấn nút Sửa
  void _editNote(BuildContext context) {
    // TODO: Implement navigation to edit note screen here
    // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng sửa đang được phát triển!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title ?? 'Chi tiết ghi chú', overflow: TextOverflow.ellipsis),
        actions: [
          // Nút Sửa
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white), // Icon sửa
            onPressed: () => _editNote(context), // Gọi hàm xử lý sửa
            tooltip: 'Chỉnh sửa ghi chú',
          ),
          // Nút Xóa (được comment lại, bạn có thể bỏ comment để sử dụng)
          // IconButton(
          //   icon: const Icon(Icons.delete, color: Colors.white),
          //   onPressed: () { /* Xử lý xóa */ },
          //   tooltip: 'Xóa ghi chú',
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title ?? 'Không có tiêu đề',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (note.category != null && note.category!.isNotEmpty)
                    Chip(
                      label: Text(note.category!), 
                      backgroundColor: Colors.blue.shade100, 
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                  if (note.priority != null && note.priority!.isNotEmpty)
                    Chip(
                      label: Text(note.priority!), 
                      backgroundColor: _getPriorityColor(note.priority), 
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                note.content ?? 'Không có nội dung chi tiết.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tạo lúc: ${_formatDateTime(note.createdAt)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text('Cập nhật: ${_formatDateTime(note.updatedAt)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm định dạng ngày giờ
  String _formatDateTime(DateTime dateTime) {
    return dateTime.toLocal().toString().split('.')[0];
  }
}
