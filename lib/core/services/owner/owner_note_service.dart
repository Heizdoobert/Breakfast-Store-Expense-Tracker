import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

import '../../../Model/note_model.dart';

class OwnerNoteService {
  final DatabaseService db;
  OwnerNoteService(this.db);

  /// Creates a new note record in the database.
  Future<Note> createNote(Map<String, dynamic> noteData) async {
    try {
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
}
