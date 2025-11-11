import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

import '../../../Model/note_model.dart';

class OwnerNoteService {
  final DatabaseService db;
  OwnerNoteService(this.db);

  /// Creates a new note record in the database.
  Future<Note> createNote(Map<String, dynamic> noteData) async {
    try {
      // Giả sử db.insert trả về một Map của bản ghi vừa được tạo
      final responseData = await db.insert('notes', noteData);
      return Note.fromJson(responseData);
    } catch (e) {
      throw ServerException('Error creating note: $e');
    }
  }

  /// Fetches all notes from the database.
  Future<List<Note>> getAllNotes() async {
    try {
      final response = await db.getAll('notes');
      return response.map((e) => Note.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Error fetching notes: $e');
    }
  }

  // ================== BƯỚC 1: THÊM HÀM `updateNote` ==================
  /// Updates an existing note in the database.
  ///
  /// - `note`: Đối tượng Note chứa thông tin mới.
  ///           Hàm `toJson()` của nó sẽ được dùng để lấy dữ liệu cập nhật.
  Future<Note> updateNote(Note note) async {
    try {
      // Giả sử hàm `db.update` nhận vào (tên bảng, id của bản ghi, dữ liệu Map để cập nhật).
      // Hàm `note.toJson()` sẽ chuyển đổi đối tượng Note thành một Map<String, dynamic>
      // với các khóa `snake_case` khớp với tên cột trong CSDL.
      final responseData = await db.update('notes', note.id, note.toJson());

      // Supabase thường trả về bản ghi đã được cập nhật,
      // chúng ta chuyển nó lại thành đối tượng Note.
      return Note.fromJson(responseData);
    } catch (e) {
      throw ServerException('Error updating note: $e');
    }
  }

  // ================== BƯỚC 2: THÊM HÀM `deleteNote` ==================
  /// Deletes a note from the database by its ID.
  Future<void> deleteNote(int noteId) async {
    try {
      // Giả sử hàm `db.delete` nhận vào (tên bảng, id của bản ghi cần xóa).
      await db.delete('notes', noteId);
    } catch (e) {
      throw ServerException('Error deleting note: $e');
    }
  }
}
