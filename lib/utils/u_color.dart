import 'package:flutter/material.dart';

class MColors {
  static Color textFieldBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff333333)
        : Colors.transparent;
  }

  static Color buttonColor() {
    return main; //Color(0xffFE6976);
  }

  static Color main = Colors.blueAccent.shade100;

  static Color backgroundCitaColor() {
    return Color(0xffFFE0E3);
  }

  static Color secondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff333333)
        : Color(0xffE4E4E4).withOpacity(0.6);
  }

  static Color secondaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff333333)
        : Color(0xffE1E1E1);
  }

  static Color thirdBackgroundColor(BuildContext context) {
    //212226
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff212226)
        : Colors.white;
  }

  static Color secondaryTextColorDef(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xffA3A3A3)
        : Colors.grey.shade600;
  }

  static Color textFieldBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.transparent
        : Color(0xffE1E1E1).withOpacity(1);
  }

  static Color cardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff303134)
        : Colors.white;
  }

  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black // Color(0xff222327)
        : Colors.white;
  }

  static Color dialogsColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff141414) // Color(0xff222327)
        : Colors.white;
  }

  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color textFieldEnabledBorderColor() {
    return Color(0xffFE6080);
  }

  static navigationBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xff191A1D) //Color(0xff323345) //Color(0xff191A1D)
        : Colors.white;
  }
}
