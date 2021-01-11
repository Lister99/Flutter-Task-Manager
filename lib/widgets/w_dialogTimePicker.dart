import 'package:flutter/material.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/widgets/w_customTimeVertical.dart';

class DialogTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final bool isDark;
  final bool isGrey;
  DialogTimePicker(
      {Key key, this.initialTime, this.isDark, this.isGrey = false})
      : super(key: key);

  @override
  _DialogTimePickerState createState() => _DialogTimePickerState();
}

class _DialogTimePickerState extends State<DialogTimePicker> {
  TimeOfDay _time;
  @override
  void initState() {
    _time = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDark ? Color(0xff1C1C1E) : Colors.white,
      titlePadding: EdgeInsets.zero,
      title: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        elevation: 0,
        margin: EdgeInsets.zero,
        color: widget.isGrey ? Colors.black : MColors.main,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Seleccione una hora',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          CustomTimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffBCBCBC)),
            highlightedTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MColors.main,
            ),
            spacing: 10,
            itemHeight: 30,
            isForce2Digits: true,
            onTimeChange: (value) {
              if (value != null) {
                setState(() {
                  _time = TimeOfDay(hour: value.hour, minute: value.minute);
                });
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
            color: widget.isDark ? Color(0xff1C1C1E) : Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            elevation: 0,
            child: Text('Cancelar',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark
                        ? Color(0xffBCBCBC)
                        : Colors.grey.shade500))),
        RaisedButton(
            color: widget.isDark ? Color(0xff1C1C1E) : Colors.white,
            onPressed: () {
              Navigator.pop(context, _time);
            },
            elevation: 0,
            child: Text('Aceptar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MColors.main,
                ))),
      ],
    );
  }
}
