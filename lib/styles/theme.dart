import 'package:flutter/material.dart';

class ThemeStyle{
  static ThemeData lightTheme(){
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.yellow,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
        ),
        primaryColor: Colors.yellow,
        textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            )
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.black54,
          )
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.yellow,
        )
    );
  }

  static ThemeData darkTheme(){
    Color blackBackground = Color(616161);
    return ThemeData(
      //scaffoldBackgroundColor: blackBackground,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
            brightness: Brightness.dark,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white30,
        )
    );
  }
}