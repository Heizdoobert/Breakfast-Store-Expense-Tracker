
import 'package:extractorapplication/Model/Note.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesPageController {
  static const String _tableName = 'notes';
  var notes = <Note>[];

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'myExpenseDatabase.db');

    return await openDatabase(
      path,
      version: 1, // Tăng version nếu bạn thay đổi schema
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            title TEXT NOT NULL,
            content TEXT,
            category TEXT,
            priority TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Thêm ghi chú mới (Create)
  Future<int> addNote(Note note) async {
    final db = await database;
    return await db.insert(_tableName, note.toMap());
  }

  /// Lấy tất cả các ghi chú (Read All)
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  /// Cập nhật một ghi chú (Update)
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// Xóa một ghi chú theo ID (Delete)
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> fetchNotes(int userId) async {
    final result = await getAllNotes();
    notes.assignAll(result);
  }

  Future<void> deleteNoteAndRefresh(int id, int userId) async {
    await deleteNote(id);
    await fetchNotes(userId);
  }
}
