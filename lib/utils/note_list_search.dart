import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/styles/theme.dart';
import 'package:flutternoteapp/ui/noteListView.dart';
import 'package:flutternoteapp/ui/readNote.dart';
import 'package:flutternoteapp/utils/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'dbHelper.dart';
import 'note_notifier.dart';

class NoteListSearch extends SearchDelegate {
  NoteListSearch()
      : super(
          searchFieldLabel: "Search note",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  var dbHelper = DbHelper();
  //Future<List<Note>> notes;

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    assert(context != null);
    final ThemeData themeData = Theme.of(context);
    return themeData;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final noteNotifier = Provider.of<NoteNotifier>(context, listen: false);
    return StatefulBuilder(
      builder: (context, modalState) => Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: FutureBuilder(
          future: dbHelper.getFilteredNotes(query),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var note = snapshot.data;
              return ListView.builder(
                itemCount: note.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      bool result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadNote(snapshot.data[index]);
                      }));
                      if (result == true) {
                        noteNotifier.getFilteredNote(query);
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
                            color:
                                getCategoryColor(snapshot.data[index].category),
                            onTap: () {
                              _delete(snapshot.data[index], context);
                              modalState(() {});
                            },
                          ),
                        )
                      ],
                      child: CustomList(
                        thumbnail: Container(
                          width: 5.0,
                          height: MediaQuery.of(context).size.height,
                          color:
                              getCategoryColor(snapshot.data[index].category),
                        ),
                        note: snapshot.data[index].text,
                        category: Text(
                          snapshot.data[index].category,
                          style: TextStyle(
                            color:
                                getCategoryColor(snapshot.data[index].category),
                          ),
                        ),
                        date: snapshot.data[index].date,
                      ),
                    ),
                  );
                },
              );
            }
            if (snapshot.data == null || snapshot.data.length == 0) {
              //print(snapshot.data);
              return Center(
                child: Text("kamui"),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }

  Color getCategoryColor(String category) {
    switch (category) {
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

  void _delete(Note note, BuildContext context) async {
    final noteNotifier = Provider.of<NoteNotifier>(context, listen: false);
    int result = await dbHelper.deleteNote(note.id);
    if (result != 0) {
      _showFlushBar(context);
    }
    //please help me before i lose my mind
    noteNotifier.getFilteredNote(query);
  }

  void _showFlushBar(BuildContext context) {
    Flushbar(
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      message: "Note Deleted",
      duration: Duration(seconds: 4),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    )..show(context);
  }
}
