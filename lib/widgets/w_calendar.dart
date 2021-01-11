import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/widgets/w_customCalendar.dart';
import 'package:scheduleapp/widgets/w_text.dart';

typedef OnDatePressed = void Function(DateTime date);

class CalendarScreen extends StatefulWidget {
  final OnDatePressed onDatePressed;
  final bool isBirthDay;
  final DateTime initialDate;
  CalendarScreen(
      {Key key, this.onDatePressed, this.isBirthDay = false, this.initialDate})
      : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    //BuildContext scaContext;
    Size _size;
    //ThemeManager.asignTheme(context);
    _size = MediaQuery.of(context).size;
    return Builder(builder: (contextSca) {
      //scaContext = contextSca;
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
              backgroundColor: MColors.dialogsColor(context),
              titlePadding: EdgeInsets.only(top: 10),
              title: Card(
                color: MColors.dialogsColor(context),
                elevation: 0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: _size.width * 0.05),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: Text(
                          'Seleccione una fecha',
                          style: CText.primarycustomText(
                              1.8, context, 'RobotoBold'),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        )),
                      ],
                    )),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: _size.width * 0.01, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              content: SingleChildScrollView(
                  child: Container(
                      width: double.maxFinite,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Localizations(
                                locale: Locale('es'),
                                delegates: [
                                  GlobalMaterialLocalizations.delegate,
                                  GlobalWidgetsLocalizations.delegate
                                ],
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                      primaryColor: MColors.buttonColor(),
                                      backgroundColor: Colors.black,
                                      dialogBackgroundColor: Color(0xff1C1C1E),
                                      accentTextTheme: TextTheme(
                                          subtitle1:
                                              TextStyle(color: Colors.white)),
                                      textTheme: TextTheme(
                                          subtitle1: TextStyle(
                                              color: MColors.buttonColor())),
                                      brightness: Brightness.dark,
                                      splashColor: MColors.buttonColor(),
                                      accentColor: MColors.buttonColor(),
                                    ),
                                    child: CustomCalendarDatePicker(
                                      initialDate: widget.isBirthDay
                                          ? widget.initialDate == null
                                              ? DateTime(
                                                  DateTime.now().year - 17,
                                                  12,
                                                  31)
                                              : widget.initialDate
                                          : DateTime.now(),
                                      onDateChanged: (date) {
                                        if (widget.onDatePressed != null)
                                          widget.onDatePressed(date);
                                      },
                                      firstDate: DateTime(
                                          DateTime.now().year - 77, 12, 31),
                                      lastDate: widget.isBirthDay
                                          ? DateTime(
                                              DateTime.now().year - 17, 12, 31)
                                          : DateTime(
                                              DateTime.now().year + 1, 12, 31),
                                    )))
                          ])))));
    });
  }
}
