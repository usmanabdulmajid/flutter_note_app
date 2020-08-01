import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/screens/addNote.dart';
import 'package:flutternoteapp/screens/noteListView.dart';
import 'package:flutternoteapp/screens/readNote.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  var dbHelper;
  Future<List<Note>> notes;
  List<Note> note;
  int count = 0;
  @override
  initState(){
    super.initState();
    dbHelper = DbHelper();
    updateList();
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
        title: Center(
            child: Text("Note App")
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddNote(Note("","","uncategorized"));
          }));
          if(result == true){
            updateList();
          }
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: FutureBuilder(
          future: notes,
          builder: (context, snapshot){
            if(snapshot.hasData){
              var note = snapshot.data;
              return ListView.builder(
                itemCount: note.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () async{
                      bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return  ReadNote(snapshot.data[index]);
                      }));
                      if(result == true){
                        updateList();
                      }
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: CustomList(
                          thumbnail: Container(
                            width: 5.0,
                            height: MediaQuery.of(context).size.height,
                            color: getCategoryColor(snapshot.data[index].category),
                          ),
                          note: snapshot.data[index].text,
                          category: Text(snapshot.data[index].category, style: TextStyle(
                            color: getCategoryColor(snapshot.data[index].category),
                          ),),
                          date: snapshot.data[index].date,
                        ),
                      )
                    ),
                  );
                },
              );
            }
            if(snapshot.data == null || snapshot.data.length == 0){
              return Center(
                child: Text("No Notes Found"),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _delete(Note note) async{
    int result = await dbHelper.deleteNote(note.id);
    if(result != 0){
      _showSnackBar("Note Deleted Successfully");
    }
  }

  void _showSnackBar(String message){
    final snackBar = SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
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
      case "Home":
        return Colors.indigo;
        break;
      default:
        return Colors.green;
    }
  }
}
