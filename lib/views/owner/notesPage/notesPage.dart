import 'package:flutter/material.dart';
import 'package:extractorapplication/Model/Note.dart';
import 'package:extractorapplication/views/owner/notesPage/widget/note_detail_page.dart';

import '../../../Controller/owner/notes_page_controller.dart';
import '../../share/add_note_view.dart'; // Import trang chi tiết

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Sử dụng Controller mới
  final NotesPageController _notesPageController = NotesPageController();
  List<Note> _notes = [];
  bool _isLoading = true;
  String _errorMessage = ''; // Để hiển thị lỗi

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset lỗi khi tải lại
    });
    try {
      final notes = await _notesPageController.getAllNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Lưu thông báo lỗi
        _isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách ghi chú'),
        // Tùy chỉnh AppBar nếu muốn
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            colors: [Color(0xFF007BFF), Color(0xFF0056b3)],
              begin: Alignment.topLeft,
           end: Alignment.bottomRight,
             ),
           ),
         ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            builder: (BuildContext bc) {
              return const AddNoteView();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      // Hiển thị lỗi nếu có
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $_errorMessage'),
            const SizedBox(height: 10),
            ElevatedButton( // Nút thử tải lại
              onPressed: _loadNotes,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (_notes.isEmpty) {
      return const Center(child: Text('Chưa có ghi chú nào.'));
    } else {
      return ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final Note note = _notes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.title ?? 'Không có tiêu đề',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 18),
                        onPressed: () {
                          _navigateToNoteDetail(context, note);
                        },
                        tooltip: 'Xem chi tiết',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content ?? 'Không có nội dung chi tiết.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      if (note.category != null && note.category!.isNotEmpty)
                        Chip(label: Text(note.category!), backgroundColor: Colors.blue.shade100, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), labelStyle: const TextStyle(fontSize: 12)),
                      if (note.priority != null && note.priority!.isNotEmpty)
                        Chip(label: Text(note.priority!), backgroundColor: _getPriorityColor(note.priority), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), labelStyle: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Cập nhật: ${note.createdAt.toLocal().toString().split('.')[0]}', 
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Hàm điều hướng đến trang chi tiết ghi chú
  void _navigateToNoteDetail(BuildContext context, Note note) {
    // Đảm bảo NoteDetailPage đã được định nghĩa và import đúng
    // Sử dụng Navigator.push để điều hướng.
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)));
  }
}
