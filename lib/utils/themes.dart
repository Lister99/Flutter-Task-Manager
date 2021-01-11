import 'package:flutter/material.dart';

class Themes {
  static ThemeData light = new ThemeData(
    brightness: Brightness.light,
    backgroundColor: Color(0xffF9F9F9),
    buttonColor: Color(0xffAE8D6A),
    primaryColorLight: Color.fromRGBO(225, 228, 236, 100), //BoxColor
    accentColor: Color.fromRGBO(114, 114, 114, 100), //SecondPrimaryText
    splashColor: Color.fromRGBO(69, 79, 99, 1),
    selectedRowColor: Color.fromRGBO(201, 201, 202, 1),
    primaryColor: Color.fromRGBO(254, 169, 15, 1),
    indicatorColor: Color(0xffFE6080),
    cursorColor: Color(0xffFE6080),
    textSelectionColor: Color(0xffFE6080),
  );
  static ThemeData dark = new ThemeData(
    brightness: Brightness.dark,
    splashColor: Colors.white,
    backgroundColor: Color(0xff000000),
    indicatorColor: Color(0xffFE6080),
    cursorColor: Color(0xffFE6080),
    buttonColor: Color(0xff8E6849),
    //buttonColor: Color.fromRGBO(252, 185, 34, 1),
    //primaryColorLight: Color.fromRGBO(42, 49, 67, 100),
    primaryColorLight: Color.fromRGBO(18, 21, 36, 1),
    accentColor: Color.fromRGBO(159, 160, 165, 100),
    selectedRowColor: Color.fromRGBO(86, 99, 134, 1),
    primaryColor: Color.fromRGBO(254, 169, 15, 1),
  );
}
