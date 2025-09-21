import 'package:extractorapplication/Database/db_help.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Note.dart';

class NoteController {
  final DBHelper _dbHelper = DBHelper();
  static List<Note> _notes = [];

  List<Note> get notes => _notes;

  //create
  Future<Note?> addNote(String title, String content, String category, String priority) async {
    final db = await _dbHelper.db;

    final id = await db!.insert('notes', {
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
        title: title,
        content: content,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _notes.add(newNote);
      return newNote;
    }
    return null;
  }

  //show
  Future<List<Note>> getUserNotes() async {
    final db = await _dbHelper.db;

    // Nếu có thông tin user đăng nhập, có thể thêm điều kiện where
    var res = await db!.query('notes', orderBy: 'created_at DESC');

    _notes = res.map((noteMap) => Note.fromMap(noteMap)).toList();
    return _notes;
  }

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

  //update
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
      final index =  _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = Note(
          id: id,
          title: title,
          content: content,
          category: category,
          priority: priority,
          createdAt: _notes[index].createdAt,
          updatedAt: DateTime.now(),
        );
      }
    }
    return result;
  }

  //delete
  Future<int> deleteNote(int id) async {
    final db = await _dbHelper.db;

    final result = await db!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Xóa khỏi danh sách local nếu thành công
    if (result > 0) {
      _notes.removeWhere((note) => note.id == id);
    }
    return result;
  }

  //fillter
  Future<List<Note>> getNotesByCategory(String category) async {
    final db = await _dbHelper.db;

    var res = await db!.query(
      'notes',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return res.map((noteMap) => Note.fromMap(noteMap)).toList();
  }

  //findding note
  Future<List<Note>> searchNotes(String query) async {
    final db = await _dbHelper.db;

    var res = await db!.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return res.map((noteMap) => Note.fromMap(noteMap)).toList();
  }

  //tag note done
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
}