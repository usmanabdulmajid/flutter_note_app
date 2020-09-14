import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class AddNote extends StatelessWidget {
  final Note note;
  AddNote(this.note);
  var dbHelper = DbHelper();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = note.text;
    return Scaffold(
      appBar: AppBar(
        leading: Align(
            alignment: Alignment(0,0),
            child: GestureDetector(
              child: Text("   Cancel", style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              onTap: (){
                Navigator.pop(context, true);
                Fluttertoast.showToast(
                  msg: "Note Not Saved",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black12,
                );
              },
            )
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment(0,0),
              child: GestureDetector(
                child: Text("Save    ", style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                onTap: (){
                  _save(context);
                },
              )
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: TextField(
                    controller:  controller,
                    decoration: InputDecoration(
                      hintText: "Type note",
                    ),
                    maxLines: null,
                    onChanged: (value){
                      updateText();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Divider(),
              ),
              Container(
                //alignment: Alignment.bottomCenter,
                child: ButtonBar(
                  //add toast for each category
                  buttonPadding: EdgeInsets.only(left: 42.0),
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.do_not_disturb_on),
                      onPressed: (){
                        note.category = "Uncategorized";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.work),
                      iconSize: 21.0,
                      onPressed: (){
                        note.category = "Work";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      iconSize: 26.0,
                      onPressed: (){
                        note.category = "Family Affair";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesome.book),
                      iconSize: 20.0,
                      onPressed: (){
                        note.category = "Study";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: (){
                        note.category = "Personal";
                        _showToast();
                      },
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
  void updateText(){
    note.text = controller.text;
  }

  void _showToast(){
    Fluttertoast.showToast(
      msg: note.category,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 10,
      backgroundColor: getCategoryColor(note.category),
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

  void _save(BuildContext context) async{
    Navigator.pop(context, true);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
      result = await dbHelper.updateNote(note);
    } else {
      result = await dbHelper.insertNote(note);
    }
    if(result != 0){
      Fluttertoast.showToast(
        msg: "Note Saved",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white30,
      );
    } else{
      Fluttertoast.showToast(
          msg: "Note Not Saved",
          gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white30,
      );
    }

  }

}
