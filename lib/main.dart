import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternoteapp/styles/theme.dart';
import 'package:flutternoteapp/ui/noteList.dart';
import 'package:flutternoteapp/ui/noteListView.dart';
import 'package:flutternoteapp/utils/note_notifier.dart';
import 'package:flutternoteapp/utils/popup_notifier.dart';
import 'package:flutternoteapp/utils/theme_notifier.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}
//main.dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> ThemeNotifier()),
        ChangeNotifierProvider(create: (context)=> NoteNotifier(),),
        ChangeNotifierProvider(create: (context)=> PopupNotifier(),),
      ],
      child: MatApp(),
    );
  }
}

class MatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeNotifier.isDarkTheme == true ? ThemeStyle.darkTheme() : ThemeStyle.lightTheme(),
      home: NoteList(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
            alignment: Alignment(0,0),
            child: GestureDetector(
              child: Text("   Cancel"),
              onTap: (){

              },
            )
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment(0,0),
              child: GestureDetector(
                child: Text("Save    "),
                onTap: (){

                },
              )
          ),
        ],
      ),
      body:  Container(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: CustomList(
                    thumbnail: Container(
                      width: 5.0,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.green,
                    ),
                    note: "My first note",
                    category: Text("work"),
                    date: "2020/07/29",
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
