import 'package:flutter/material.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/utils/u_responsive.dart';

class CText {
  static Responsive _responsive;
  static TextStyle menucustomText(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
      color: Colors.white,
      fontSize: _responsive.ip(responsivePercentSize),
      fontFamily: fontFamily,
    );
  }

  static TextStyle menucustomOptionText(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
      color: Colors.white.withOpacity(0.77),
      fontSize: _responsive.ip(responsivePercentSize),
      fontFamily: fontFamily,
    );
  }

  static TextStyle customColorText(double responsivePercentSize,
      BuildContext context, String fontFamily, Color color) {
    _responsive = Responsive(context);
    return TextStyle(
      color: color,
      fontSize: _responsive.ip(responsivePercentSize),
      fontFamily: fontFamily,
    );
  }

  static TextStyle customSizedColorText(double responsivePercentSize,
      BuildContext context, String fontFamily, Color color) {
    _responsive = Responsive(context);
    return TextStyle(
      color: color,
      fontSize: responsivePercentSize,
      fontFamily: fontFamily,
    );
  }

  static TextStyle secondarycustomText(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: _responsive.ip(responsivePercentSize),
      fontFamily: fontFamily,
    );
  }

  static CircularProgressIndicator progressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(MColors.buttonColor()),
      strokeWidth: 5.0,
    );
  }

  static TextStyle primarycustomText(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
        fontSize: _responsive.ip(responsivePercentSize),
        fontFamily: fontFamily,
        color: MColors.textColor(context));
  }

  static TextStyle primarySizedcustomText(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
        fontSize: responsivePercentSize,
        fontFamily: fontFamily,
        color: MColors.textColor(context));
  }

  static TextStyle primarycustomLink(
      double responsivePercentSize, BuildContext context, String fontFamily) {
    _responsive = Responsive(context);
    return TextStyle(
        fontSize: _responsive.ip(responsivePercentSize),
        fontFamily: fontFamily,
        color: Color(0xffFE6976));
  }
}
