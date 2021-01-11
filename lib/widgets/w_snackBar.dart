import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/utils/u_responsive.dart';
import 'package:scheduleapp/widgets/w_text.dart';

class SnackBars {
  static Responsive responsive;
  static void showCorrectSnackBar(BuildContext scaContext, BuildContext context,
      IconData icon, String title, String message) {
    responsive = Responsive(context);
    Flushbar(
      titleText: Text(
        title,
        style: CText.primarycustomText(2.2, context, 'RobotoBold'),
      ),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(6), vertical: 20),
      messageText: Text(
        message,
        style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xffA6A6A6).withOpacity(0.62)
          : Color(0xff000000).withOpacity(0.62),
      icon: Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color(0xff27EBA7),
                    Color(0xff32AE85),
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: responsive.ip(3),
              ),
            ),
          )),
      barBlur: 4,
      isDismissible: true,
      duration: Duration(seconds: 2),
    )..show(scaContext);
  }

  static void showErrorSnackBar(BuildContext scaContext, BuildContext context,
      IconData icon, String title, String message) {
    responsive = Responsive(context);
    Flushbar(
      titleText: Text(
        title,
        style: CText.primarycustomText(2.2, context, 'RobotoBold'),
      ),
      messageText: Text(
        message,
        style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xffA6A6A6).withOpacity(0.62)
          : Color(0xff000000).withOpacity(0.62),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(6), vertical: 20),
      icon: Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color(0xffE55F6E),
                    Color(0xffB53443),
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: responsive.ip(3),
              ),
            ),
          )),
      barBlur: 4,
      isDismissible: true,
      duration: Duration(seconds: 2),
    )..show(scaContext);
  }

  static void showErrorSnackBarOptions(
      BuildContext scaContext,
      BuildContext context,
      IconData icon,
      String title,
      String message,
      VoidCallback onNo,
      VoidCallback onYes) {
    responsive = Responsive(context);
    Flushbar(
      mainButton: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onYes();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Si',
                style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onNo();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'No',
                style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
              ),
            ),
          ),
        ],
      ),
      titleText: Text(
        title,
        style: CText.primarycustomText(2.2, context, 'RobotoBold'),
      ),
      messageText: Text(
        message,
        style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xffA6A6A6).withOpacity(0.62)
          : Color(0xff000000).withOpacity(0.62),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(6), vertical: 20),
      icon: Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color(0xffE55F6E),
                    Color(0xffB53443),
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: responsive.ip(3),
              ),
            ),
          )),
      barBlur: 4,
      isDismissible: false,
      duration: Duration(seconds: 1),
    )..show(scaContext);
  }

  static void classicshowErrorSnackBar(
      BuildContext scaContext, BuildContext context) {
    responsive = Responsive(context);
    Flushbar(
      titleText: Text(
        'Ups',
        style: CText.primarycustomText(2.2, context, 'RobotoBold'),
      ),
      messageText: Text(
        'Su solicitud no puedo ser procesada',
        style: CText.primarycustomText(1.8, context, 'RobotoMedium'),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xffA6A6A6).withOpacity(0.62)
          : Color(0xff000000).withOpacity(0.62),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(6), vertical: 20),
      icon: Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color(0xffE55F6E),
                    Color(0xffB53443),
                  ],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                //ResponseIcons.badservice,
                Icons.error,
                color: Colors.white,
                size: responsive.ip(3),
              ),
            ),
          )),
      barBlur: 4,
      isDismissible: true,
      duration: Duration(seconds: 1),
    )..show(scaContext);
  }
}
