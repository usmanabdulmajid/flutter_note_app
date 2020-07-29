import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';

import 'addNote.dart';
class ReadNote extends StatefulWidget {
  final Note note;
  ReadNote(this.note);
  @override
  _ReadNoteState createState() => _ReadNoteState(this.note);
}

class _ReadNoteState extends State<ReadNote> {
  final Note note;
  _ReadNoteState(this.note);
  var dbHelper;
  Future<List<Note>> notes;
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }
  updateList(){
    setState(() {
      notes = dbHelper.getNotes();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reading"),
      ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () async{
            bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddNote(note);
            }));
            if(result == true){
              updateList();
            }
          },
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 0.0),
          child: ListView(
            children: <Widget>[
              Text(note.category),
              SizedBox(height: 30.0,),
              Text(note.text),
            ],
          ),
        )
    );
  }
}
