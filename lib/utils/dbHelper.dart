import 'dart:io';

import 'package:flutternoteapp/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class DbHelper{
  static Database _db;
  static const String dbName = "note.db";
  static const String noteTable = "noteTable";
  static const String colId = "id";
  static const String colNote = "text";
  static const String colDate = "date";
  static const String colCategory = "category";

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;
    var noteDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return noteDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNote TEXT, $colDate TEXT, $colCategory TEXT)");
  }

  Future<List<Note>> getNotes() async{
    Database dbClient = await db;
    //check the order by letter you dum ass
    List<Map> map = await dbClient.query(noteTable, columns: [colId, colNote, colDate, colCategory]);
    List<Note> notes = [];
    if(map.length > 0){
      for(int i = 0; i < map.length; i++){
        notes.add(Note.fromMpObject(map[i]));
      }
    }
    return notes;
  }

  Future<List<Note>> getFilteredNotes(String query) async {
    Database dbClient = await db;
    //check the order by letter you dum ass
    List<Map> map = await dbClient.query(noteTable, columns: [colId, colNote, colDate, colCategory]);
    List<Note> notes = [];
    if(map.length > 0){
      for(int i = 0; i < map.length; i++){
        notes.add(Note.fromMpObject(map[i]));
      }
    }
    List<Note> searchedNotes = [];
    if(query != null && query.isNotEmpty){
      for(int i = 0; i < notes.length; i++){
        if(notes[i].text.toLowerCase().contains(query)){
          searchedNotes.add(notes[i]);
        }
      }
    }
    return searchedNotes;

  }

  Future<int> insertNote(Note note) async {
    Database dbClient = await db;
    var result = await dbClient.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database dbClient = await db;
    var result = await dbClient.update(noteTable, note.toMap(), where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database dbClient = await db;
    var result = await dbClient.rawDelete("DELETE FROM $noteTable WHERE $colId = $id");
    return result;
  }

  Future<int> getCount() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> x = await dbClient.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future close() async {
    Database dbClient = await db;
    dbClient.close();
  }

}