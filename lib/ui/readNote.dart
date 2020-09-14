import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:flutternoteapp/utils/note_notifier.dart';
import 'package:provider/provider.dart';
import 'addNote.dart';


// ignore: must_be_immutable
class ReadNote extends StatelessWidget {
  final Note note;
  ReadNote(this.note);
  var dbHelper;
  Future<List<Note>> notes;
  @override
  void initState() {
    dbHelper = DbHelper();
  }
  @override
  Widget build(BuildContext context) {
    final noteNotifier = Provider.of<NoteNotifier>(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reading"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context, true);
            },
          ),
        ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            onPressed: () async {
              bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                return AddNote(note);
              }));
              if(result == true){
                //Do shit
                noteNotifier.getNoteFromDb();

              }
            },
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 0.0),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Text(".", style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: getCategoryColor(note.category),
                    ),),
                    Positioned(
                      top: 24,
                      left: 26,
                      child: Text(note.category, style: TextStyle(
                        fontSize: 14.0,
                        color: getCategoryColor(note.category),
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 30.0,),
                Text(note.text, style: TextStyle(
                  fontSize: 20.0,
                ),),
              ],
            ),
          )
      ),
    );
  }

  Color getCategoryColor(String category){
    switch (category){
      case "Uncategorized":
        return Colors.green;
        break;
      case "Personal":
        return Colors.yellow;
        break;
      case "Work":
        return Colors.purple;
        break;
      case "Study":
        return Colors.red;
        break;
      case "Family Affair":
        return Colors.indigo;
        break;
      default:
        return Colors.green;
    }
  }
}
