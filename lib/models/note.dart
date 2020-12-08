

class Note{
  int _id;
  String _text;
  String _date;
  String _category;

  Note(this._text, this._date, this._category);

  int get id => _id;
  String get text => _text;
  String get date => _date;
  String get category => _category;

  set text(String value){
    this._text = value;
  }
  set date(String value){
    this._date = value;
  }
  set category(String value){
    this._category = value;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["text"] = _text;
    map["date"] = _date;
    map["category"] = _category;
    return map;
  }

  Note.fromMpObject(Map<String, dynamic> map){
    _id = map["id"];
    _text = map["text"];
    _date = map["date"];
    _category = map["category"];
  }
}