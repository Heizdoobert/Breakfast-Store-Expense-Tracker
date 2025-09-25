import 'package:extractorapplication/Controller/noteController.dart'; 
import 'package:extractorapplication/Model/Note.dart'; 
import 'package:extractorapplication/services/saveSession.dart';
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
    });
    try {
      final notes = await _noteController.getAllNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notes: $e');
      setState(() {
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
      userId: userId, // Truyền userId đã lấy
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
      priority: _selectedPriority!,
      createdAt: DateTime.now(), // Sử dụng DateTime.now()
      updatedAt: DateTime.now(), // Sử dụng DateTime.now()
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
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thêm ghi chú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              const Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Nhập tiêu đề ghi chú',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Nội dung'),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung chi tiết',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: priorities
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPriority = value),
                decoration: InputDecoration(
                  labelText: 'Độ ưu tiên',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu ghi chú'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text('Các ghi chú đã lưu:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
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
                      child: ListTile(
                        title: Text(note.title ?? 'Không có tiêu đề'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.content ?? 'Không có nội dung'),
                            if (note.category != null) Text('Danh mục: ${note.category}'),
                            if (note.priority != null) Text('Ưu tiên: ${note.priority}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(note.id! ?? -1);
                              },
                            ),
                          ],
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

  Future<void> _showDeleteConfirmationDialog(int noteId) async {
    // Kiểm tra xem noteId có hợp lệ không trước khi hiển thị dialog
    if (noteId == -1) {
        print('Invalid note ID for deletion.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể xóa ghi chú không hợp lệ'))
        );
        return;
    }
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
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); 
                try {
                  await _noteController.deleteNote(noteId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa ghi chú')),
                  );
                  _loadNotes();
                } catch (e) {
                  print('Error deleting note: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lỗi khi xóa ghi chú')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
