// lib/Controller/NoteController.dart
import 'package:extractorapplication/Database/db_help.dart';
import 'package:extractorapplication/Controller/AuthController.dart';
import '../Model/Note.dart';

class NoteController {
  final DBHelper _dbHelper = DBHelper();
  final AuthController _authController = AuthController();
  static List<Note> _userNotes = [];

  List<Note> get userNotes => _userNotes;

  // Thêm ghi chú mới
  Future<Note?> addNote(String title, String content, String category, String priority) async {
    final db = await _dbHelper.db;
    final currentUser = _authController.currentUser;

    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    final id = await db!.insert('notes', {
      'user_id': currentUser.id,
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (id > 0) {
      final newNote = Note(
        id: id,
        userId: currentUser.id,
        title: title,
        content: content,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _userNotes.add(newNote);
      return newNote;
    }
    return null;
  }

  // Lấy tất cả ghi chú của user hiện tại
  Future<List<Note>> getUserNotes() async {
    final db = await _dbHelper.db;
    final currentUser = _authController.currentUser;

    if (currentUser == null) {
      return [];
    }

    var res = await db!.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [currentUser.id],
      orderBy: 'created_at DESC',
    );

    _userNotes = res.map((noteMap) => Note.fromMap(noteMap)).toList();
    return _userNotes;
  }

  // Lấy ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    final db = await _dbHelper.db;

    var res = await db!.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return Note.fromMap(res.first);
    }
    return null;
  }

  // Cập nhật ghi chú
  Future<int> updateNote(int id, String title, String content, String category, String priority) async {
    final db = await _dbHelper.db;

    final result = await db!.update(
      'notes',
      {
        'title': title,
        'content': content,
        'category': category,
        'priority': priority,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Cập nhật trong danh sách local nếu thành công
    if (result > 0) {
      final index = _userNotes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _userNotes[index] = Note(
          id: id,
          userId: _userNotes[index].userId,
          title: title,
          content: content,
          category: category,
          priority: priority,
          createdAt: _userNotes[index].createdAt,
          updatedAt: DateTime.now(),
        );
      }
    }

    return result;
  }

  // Xóa ghi chú
  Future<int> deleteNote(int id) async {
    final db = await _dbHelper.db;

    final result = await db!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Xóa khỏi danh sách local nếu thành công
    if (result > 0) {
      _userNotes.removeWhere((note) => note.id == id);
    }

    return result;
  }

  // Đánh dấu ghi chú là đã hoàn thành
  Future<int> markAsCompleted(int id) async {
    final db = await _dbHelper.db;

    final result = await db!.update(
      'notes',
      {
        'is_completed': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  // Lấy ghi chú của user hiện tại trong ngày hôm nay
  Future<List<Note>> getTodayNotes() async {
    final db = await _dbHelper.db;
    final currentUser = _authController.currentUser;

    if (currentUser == null) {
      return [];
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final startOfTomorrow = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .toIso8601String();

    var res = await db!.query(
      'notes',
      where: 'user_id = ? AND created_at >= ? AND created_at < ?',
      whereArgs: [currentUser.id, startOfDay, startOfTomorrow],
      orderBy: 'created_at DESC',
    );

    return res.map((noteMap) => Note.fromMap(noteMap)).toList();
  }
}