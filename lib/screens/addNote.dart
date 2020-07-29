import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
class AddNote extends StatefulWidget {
  final Note note;
  AddNote(this.note);
  @override
  _AddNoteState createState() => _AddNoteState(this.note);
}

class _AddNoteState extends State<AddNote> {
  final Note note;
  _AddNoteState(this.note);
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
                  _save();
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
                  buttonPadding: EdgeInsets.only(left: 42.0),
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.do_not_disturb_on),
                      onPressed: (){
                        note.category = "Uncategorized";
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.work),
                      iconSize: 21.0,
                      onPressed: (){
                        note.category = "Work";
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      iconSize: 26.0,
                      onPressed: (){
                        note.category = "Home";
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesome.book),
                      iconSize: 20.0,
                      onPressed: (){
                        note.category = "Study";
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: (){
                        note.category = "Personal";
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

  void _save() async{
    Navigator.pop(context, true);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
      result = await dbHelper.updateNote(note);
    } else {
      result = await dbHelper.insertNote(note);
    }
    if(result != 0){
      _showAlertDialog("Status", "Note Saved Successfully");
    } else{
      _showAlertDialog("Status", "Problem Saving Note");
    }

  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
