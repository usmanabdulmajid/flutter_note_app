import 'package:flutter/material.dart';
import 'package:flutternoteapp/utils/dbHelper.dart';

class PopupNotifier extends ChangeNotifier{
  bool _isEnable;
  String _signState;
  var dbHelper = DbHelper();

  PopupNotifier(){
    getEnableState();
  }

  bool get isEnable => _isEnable;

  set setIsEnable(bool value){
     _isEnable = value;
     notifyListeners();
  }

  String get signState => _signState;

  set setSignState(String value){
    _signState = value;
    notifyListeners();
  }

  getEnableState(){
    dbHelper.getCount().then((value) {
      if(value >= 1){
        _isEnable = true;
      } else{
        _isEnable = false;
      }
      notifyListeners();
    });
  }
}