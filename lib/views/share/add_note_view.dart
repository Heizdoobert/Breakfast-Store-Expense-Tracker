import 'package:extractorapplication/Controller/noteController.dart'; 
import 'package:extractorapplication/Model/Note.dart'; 
import 'package:extractorapplication/services/saveSession.dart';
import 'package:extractorapplication/views/owner/notesPage/widget/note_detail_page.dart';
import 'package:flutter/material.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final getUserId = UserStorage();
  final NoteController _noteController = NoteController();
  String? _selectedCategory;
  String? _selectedPriority;

  List<Note> _notes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final List<String> categories = ['Công việc', 'Cá nhân', 'Khác'];
  final List<String> priorities = ['Thấp', 'Trung bình', 'Cao'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final notes = await _noteController.getAllNotes();
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notes in AddNoteView: $e'); 
      setState(() {
        _errorMessage = 'Lỗi khi tải ghi chú: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _saveNote() async {
    final userId = await UserStorage.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy userId')),
      );
      return;
    }

    if (_titleController.text.isEmpty || _selectedPriority == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề và chọn độ ưu tiên')),
      );
      return;
    }

    final note = Note(
      userId: userId, 
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
      priority: _selectedPriority!,
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(), 
    );

    try {
      await _noteController.addNote(note);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu ghi chú')),
      );
      _loadNotes(); 
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedPriority = null;
      });
    } catch (e) {
       print('Error saving note: $e');
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi lưu ghi chú')),
      );
    }
  }

  // Hàm hiển thị Bottom Sheet chi tiết
  void _showNoteDetailSheet(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext bc) {
        return NoteDetailPage(note: note);
      },
    );
  }

  // Hàm hiển thị xác nhận xóa ghi chú
  Future<void> _showDeleteConfirmationDialog(int noteId) async {
    if (noteId == -1) return; 

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(child: const Text('Hủy'), onPressed: () { Navigator.of(context).pop(); }),
            TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog xác nhận
                try {
                  // Gọi hàm xóa ghi chú từ controller
                  await _noteController.deleteNote(noteId); // Giả sử có hàm deleteNote
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa ghi chú')));
                  _loadNotes(); // Tải lại danh sách ghi chú
                } catch (e) {
                  print('Error deleting note: $e');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi khi xóa ghi chú')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm lấy màu cho chip độ ưu tiên (tên khác để tránh trùng lặp)
  Color _getNotePriorityColor(String? priority) {
    switch (priority) {
      case 'Cao': return Colors.red.shade300;
      case 'Trung bình': return Colors.orange.shade300;
      case 'Thấp': return Colors.green.shade300;
      default: return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24, top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phần Form thêm ghi chú
              const Text('Thêm ghi chú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Nhập tiêu đề ghi chú', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              const Text('Nội dung'),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(hintText: 'Nhập nội dung chi tiết', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: InputDecoration(labelText: 'Danh mục', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: priorities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _selectedPriority = value),
                decoration: InputDecoration(labelText: 'Độ ưu tiên', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save), label: const Text('Lưu ghi chú'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),

              // Phần hiển thị danh sách ghi chú đã lưu
              const SizedBox(height: 32),
              const Text('Các ghi chú đã lưu:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                 Center(child: Text(_errorMessage))
              else if (_notes.isEmpty)
                const Center(child: Text('Chưa có ghi chú nào.'))
              else
                ListView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(), 
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0), 
                      elevation: 4, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero, 
                          title: Row(
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
                              // Icon Sửa (trong danh sách ghi chú)
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue, size: 22), 
                                onPressed: () {
                                  // TODO: Implement edit functionality for list items
                                  print('Edit note tapped: ${note.id}');
                                  // Mở BottomSheet để xem/sửa ghi chú
                                  _showNoteDetailSheet(context, note); 
                                },
                                tooltip: 'Chỉnh sửa ghi chú',
                              ),
                              // Icon Xóa
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22), // Icon xóa
                                onPressed: () {
                                  // Gọi hàm xác nhận xóa với ID của ghi chú
                                  // Đảm bảo note.id là non-nullable hoặc xử lý trường hợp null
                                  if (note.id != null) {
                                    _showDeleteConfirmationDialog(note.id!); 
                                  } else {
                                     ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Không thể xóa ghi chú này (ID lỗi).'))
                                    );
                                  }
                                },
                                tooltip: 'Xóa ghi chú',
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                note.content ?? 'Không có nội dung',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: [
                                  if (note.category != null && note.category!.isNotEmpty)
                                    Chip(label: Text(note.category!), backgroundColor: Colors.blue.shade100, padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), labelStyle: TextStyle(fontSize: 12)),
                                  if (note.priority != null && note.priority!.isNotEmpty)
                                    Chip(label: Text(note.priority!), backgroundColor: _getNotePriorityColor(note.priority), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), labelStyle: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          // Thêm onTap cho cả ListTile để dễ dàng truy cập chi tiết
                          onTap: () {
                            _showNoteDetailSheet(context, note);
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
