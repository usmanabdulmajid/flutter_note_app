import 'package:flutter/material.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/ui/addNote.dart';
import 'package:flutternoteapp/ui/noteListView.dart';
import 'package:flutternoteapp/ui/readNote.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutternoteapp/utils/note_list_search.dart';
import 'package:flutternoteapp/utils/note_notifier.dart';
import 'package:flutternoteapp/utils/theme_notifier.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NoteList extends StatelessWidget {
  var dbHelper = DbHelper();
  Future<List<Note>> notes;
  List<Note> note;
  int count = 0;
  @override
  initState(){
    //dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final TextStyle tittleStyle = Theme.of(context).textTheme.headline6;
    final noteNotifier = Provider.of<NoteNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: NoteListSearch());
            },
            icon: Icon(Icons.search),
          ),

        ],
        title: Text("Note Keeper", style: tittleStyle),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 32.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: (){
                  themeNotifier.switchTheme();
                },
                child: themeNotifier.isDarkTheme == true ? Icon(Icons.wb_sunny) : Icon(Icons.brightness_3),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AddNote(Note("","","uncategorized"));
                  }));
                  if(result == true){
                    //Do shit
                    noteNotifier.getNoteFromDb();
                  }
                },
                child: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: FutureBuilder(
          future: dbHelper.getNotes(),
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
                        //Do shit
                        noteNotifier.getNoteFromDb();
                      }
                    },
                    child: Slidable(
                      actionExtentRatio: 0.25,
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        Card(

                          child: IconSlideAction(
                            caption: "Delete",
                            icon: Icons.delete,
                            color: getCategoryColor(snapshot.data[index].category),
                            onTap: (){
                             _delete(snapshot.data[index], context);
                            },
                          ),
                        )
                      ],
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
                    ),
                  );
                },
              );
            }
            if(snapshot.data == null || snapshot.data.length == 0){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _delete(Note note, BuildContext context) async{
    final noteNotifier = Provider.of<NoteNotifier>(context, listen: false);
    int result = await dbHelper.deleteNote(note.id);
    if(result != 0){
      _showFlushBar(context);
    }
    noteNotifier.getNoteFromDb();
  }

  void _showFlushBar(BuildContext context){
    Flushbar(
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      message: "Note Deleted",
      duration: Duration(seconds: 4),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    )..show(context);
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
