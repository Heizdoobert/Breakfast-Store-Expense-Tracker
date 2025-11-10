import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:flutter/cupertino.dart';
import '../../Model/note_model.dart';
import '../../core/services/owner/owner_note_service.dart';

class NoteManagementController extends BaseController {
  final OwnerNoteService _service;
  NoteManagementController(this._service);

  List<Note> notes = [];

  Future<void> _fetchData() async {
    notes = await _service.getAllNotes();
  }

  Future<void> loadNotes() async {
    await loadData(_fetchData);
  }

  Future<bool> _performAction(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('NoteManagementController Error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> addNote(Map<String, dynamic> noteData) async {
    await _performAction(() async {
      final newNote = await _service.createNote(noteData);
      notes.insert(0, newNote);
      notifyListeners();
    });
  }
}
