import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutternoteapp/models/note.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  final Note note;
  AddNote(this.note);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var dbHelper = DbHelper();

  TextEditingController controller = TextEditingController();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.text = widget.note.text;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context, true);
            Fluttertoast.showToast(
              msg: "Note Not Saved",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black12,
            );
          },
          icon: Icon(Icons.close),
          iconSize: 28.0,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              _save(context);
            },
            icon: Icon(Icons.done),
            iconSize: 28.0,
          )
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
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value){
                      updateText();
                    },
                  ),
                ),
              ),
              Spacer(),


              Container(
                //alignment: Alignment.bottomCenter,
                //button bar
                child: ButtonBar(
                  //add toast for each category
                  buttonPadding: EdgeInsets.only(left: 42.0),
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.widgets),
                      onPressed: (){
                        widget.note.category = "Uncategorized";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.work),
                      iconSize: 21.0,
                      onPressed: (){
                        widget.note.category = "Work";
                        _showToast();
                      },


                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      iconSize: 26.0,
                      onPressed: (){
                        widget.note.category = "Family Affair";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesome.book),
                      iconSize: 20.0,
                      onPressed: (){
                        widget.note.category = "Study";
                        _showToast();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: (){
                        widget.note.category = "Personal";
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
    widget.note.text = controller.text;
  }

  void _showToast(){
    Fluttertoast.showToast(
      msg: widget.note.category,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 10,
      backgroundColor: getCategoryColor(widget.note.category),
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
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(widget.note.id != null){
      result = await dbHelper.updateNote(widget.note);
    } else if(widget.note.text.isNotEmpty){
      result = await dbHelper.insertNote(widget.note);

    }
    if(result != 0 && widget.note.text.isNotEmpty){
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

  void getSnackBar(BuildContext context, String message){
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
    );
    globalKey.currentState.showSnackBar(snackBar);
  }
}
