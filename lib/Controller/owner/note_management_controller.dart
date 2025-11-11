import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/note_model.dart';
import '../../core/services/owner/owner_note_service.dart';

class NoteManagementController extends BaseController {
  final OwnerNoteService _service;
  NoteManagementController(this._service);

  List<Note> notes = [];
  String? errorMessage;

  Future<void> _fetchData() async {
    notes = await _service.getAllNotes();
  }

  Future<void> loadNotes() async {
    await loadData(_fetchData);
  }

  Future<void> addNote(Map<String, dynamic> noteData) async {
    setLoading(true);
    errorMessage = null;
    try {
      final newNote = await _service.createNote(noteData);
      notes.insert(0, newNote);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('NoteManagementController Error creating note: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateNote(Note noteToUpdate) async {
    setLoading(true);
    errorMessage = null;
    try {
      final updatedNote = await _service.updateNote(noteToUpdate);

      final index = notes.indexWhere((note) => note.id == updatedNote.id);

      if (index != -1) {
        notes[index] = updatedNote;
      }

      notifyListeners();
      setLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('NoteManagementController Error updating note: $e');
      setLoading(false);
      return false;
    }
  }

  Future<bool> deleteNote(int noteId) async {
    setLoading(true);
    errorMessage = null;
    try {
      await _service.deleteNote(noteId);
      notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
      setLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('NoteManagementController Error deleting note: $e');
      setLoading(false);
      return false;
    }
  }
}
