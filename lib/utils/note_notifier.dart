import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:flutternoteapp/utils/note_list_search.dart';

class NoteNotifier extends ChangeNotifier{
  var dbHelper = DbHelper();
  Future<List<Note>> notes;
  //NoteListSearch noteListSearch = NoteListSearch();

  NoteNotifier(){
    getNoteFromDb();
  }


  getNoteFromDb(){
    notes = dbHelper.getNotes();
    notifyListeners();
  }

  getFilteredNote(String query){
    notes = dbHelper.getFilteredNotes(query);
    notifyListeners();
  }

  getNull(){
    notes = null;
    notifyListeners();
  }

}