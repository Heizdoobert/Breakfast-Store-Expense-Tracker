import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

import '../../../Model/note_model.dart';

///Lop service note bao gom cac phuong thuc crud tren bang note
///lop giao tiep voi db ma khong can thong qua controller
///giup tach biet hoan toan voi controller de xu ly logic
class OwnerNoteService {
  final DatabaseService db;
  OwnerNoteService(this.db);

  Future<Note> createNote(Map<String, dynamic> noteData) async {
    try {
      final responseData = await db.insert('notes', noteData);
      return Note.fromJson(responseData);
    } catch (e) {
      throw ServerException('Error creating note: $e');
    }
  }

  Future<List<Note>> getAllNotes() async {
    try {
      final response = await db.getAll('notes');
      return response.map((e) => Note.fromJson(e)).toList();
    } catch (e) {
      throw ServerException('Error fetching notes: $e');
    }
  }

  Future<Note> updateNote(Note note) async {
    try {
      final responseData = await db.update('notes', note.id, note.toJson());
      return Note.fromJson(responseData);
    } catch (e) {
      throw ServerException('Error updating note: $e');
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      await db.delete('notes', noteId);
    } catch (e) {
      throw ServerException('Error deleting note: $e');
    }
  }
}
