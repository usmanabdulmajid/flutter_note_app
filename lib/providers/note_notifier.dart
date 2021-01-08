import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'file:///C:/Users/MAJID/AndroidStudioProjects/flutter_note_app-master/lib/screens/note_search_screen.dart';

class NoteNotifier extends ChangeNotifier {
  var dbHelper = DbHelper();
  Future<List<Note>> notes;
  //NoteListSearch noteListSearch = NoteListSearch();

  NoteNotifier() {
    getNoteFromDb();
  }

  getNoteFromDb() {
    notes = dbHelper.getNotes();
    notifyListeners();
  }

  getFilteredNote(String query) {
    notes = dbHelper.getFilteredNotes(query);
    notifyListeners();
  }

  getNull() {
    notes = null;
    notifyListeners();
  }
}
