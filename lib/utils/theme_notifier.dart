import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier{
  bool _isDarkTheme;
  String key = "theme_status";

  bool get isDarkTheme => _isDarkTheme;

  ThemeNotifier(){
    //_isDarkTheme = true;
    getFromPref();
  }


  switchTheme(){
    _isDarkTheme = !_isDarkTheme;
    saveToPref();
    notifyListeners();
  }
  getFromPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, _isDarkTheme);
  }
}