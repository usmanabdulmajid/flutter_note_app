import 'package:flutter/material.dart';
class _TextDescription extends StatelessWidget {
  final Widget thumbnail;
  final String note;
  final Widget category;
  final String date;
  _TextDescription({this.thumbnail, this.note, this.category, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  category,
                  SizedBox(width: 20.0,),
                  Text("$date"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class CustomList extends StatelessWidget {
  final Widget thumbnail;
  final String note;
  final String date;
  final Widget category;
  CustomList({this.thumbnail, this.note, this.date, this.category});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 60.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              thumbnail,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: _TextDescription(
                    note: note,
                    category: category,
                    date: date,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
