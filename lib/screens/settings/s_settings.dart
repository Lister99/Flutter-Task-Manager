import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/controllers/c_home.dart';
import 'package:scheduleapp/controllers/c_rutina.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/widgets/w_customSwitch.dart';
import 'package:scheduleapp/widgets/w_text.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color _tempShadeColor = Colors.blueAccent[100];
  Color _shadeColor = Colors.blue[800];

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              backgroundColor: MColors.dialogsColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(title),
              content: content,
              actions: [
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: Navigator.of(context).pop,
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() => MColors.main = _tempShadeColor);
                    Provider.of<RutinaProvider>(context, listen: false)
                        .update();
                    Provider.of<HomeProvider>(context, listen: false).update();
                    Provider.of<EtiquetaProvider>(context, listen: false)
                        .update();
                  },
                ),
              ],
            ));
      },
    );
  }

  static const themeModeOptions = [
    {'label': 'Sistema', 'value': ThemeMode.system, 'icon': Icons.settings},
    {'label': 'Claro', 'value': ThemeMode.light, 'icon': Icons.wb_sunny},
    {
      'label': 'Oscuro',
      'value': ThemeMode.dark,
      'icon': MaterialCommunityIcons.moon_full
    },
  ];
  static void _selectThemeMode(BuildContext context, ThemeMode value) async {
    ThemeModeHandler.of(context).saveThemeMode(value);
    Navigator.pop(context, value);
  }

  static Future<ThemeMode> showThemePickerDialog(
      {@required BuildContext contexts}) {
    return showDialog(
        context: contexts,
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: SimpleDialog(
                backgroundColor: MColors.dialogsColor(context),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text('Seleccione un Tema',
                    style: CText.primarycustomText(2, context, 'RobotoMedium')),
                children: themeModeOptions.map((option) {
                  return SimpleDialogOption(
                    onPressed: () =>
                        _selectThemeMode(contexts, option['value']),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(option['icon'],
                              color: Theme.of(context).accentColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            option['label'],
                            style: CText.primarycustomText(
                                1.8, context, 'RobotoMedium'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Scaffold(
        backgroundColor: MColors.backgroundColor(context),
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: MColors.backgroundColor(context),
          elevation: 0,
          title: Text(
            "Ajustes",
            style: CText.primarycustomText(2.5, context, "CircularStdBold"),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _size.width * .05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Provider.of<RutinaProvider>(context, listen: false)
                        .notificationManager
                        .showNotification(
                            value.sharedPrepeferencesGetValueIsAlarma());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          AntDesign.notification,
                          color: MColors.buttonColor(),
                        ),
                        SizedBox(
                          width: _size.width * .02,
                        ),
                        Expanded(
                          child: Text(
                            "Probar Notificacion",
                            style: CText.primarycustomText(
                                1.7, context, 'CircularStdBook'),
                          ),
                        ),
                        SizedBox(
                          width: _size.width * 0.04,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                InkWell(
                  onTap: () {
                    _openDialog(
                      "Seleccionar Color",
                      MaterialColorPicker(
                        shrinkWrap: true,
                        selectedColor: _shadeColor,
                        onColorChange: (color) =>
                            setState(() => _tempShadeColor = color),
                        onBack: () => print("Back button pressed"),
                      ),
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.colorize,
                          color: MColors.buttonColor(),
                        ),
                        SizedBox(
                          width: _size.width * .02,
                        ),
                        Expanded(
                          child: Text(
                            "Color",
                            style: CText.primarycustomText(
                                1.7, context, 'CircularStdBook'),
                          ),
                        ),
                        SizedBox(
                          width: _size.width * 0.04,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    showThemePickerDialog(contexts: this.context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          MaterialCommunityIcons.theme_light_dark,
                          color: MColors.buttonColor(),
                        ),
                        SizedBox(
                          width: _size.width * .02,
                        ),
                        Expanded(
                          child: Text(
                            "Cambiar Tema",
                            style: CText.primarycustomText(
                                1.7, context, 'CircularStdBook'),
                          ),
                        ),
                        SizedBox(
                          width: _size.width * 0.04,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings_backup_restore,
                          color: MColors.buttonColor(),
                        ),
                        SizedBox(
                          width: _size.width * .02,
                        ),
                        Expanded(
                          child: Text(
                            "Copia de Seguridad local",
                            style: CText.primarycustomText(
                                1.7, context, 'CircularStdBook'),
                          ),
                        ),
                        SizedBox(
                          width: _size.width * 0.04,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          AntDesign.google,
                          color: MColors.buttonColor(),
                        ),
                        SizedBox(
                          width: _size.width * .02,
                        ),
                        Expanded(
                          child: Text(
                            "Copia de Seguridad Google Drive",
                            style: CText.primarycustomText(
                                1.7, context, 'CircularStdBook'),
                          ),
                        ),
                        SizedBox(
                          width: _size.width * 0.04,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: MColors.buttonColor(),
                      ),
                      SizedBox(
                        width: _size.width * .02,
                      ),
                      Expanded(
                        child: Text(
                          "Permitir Cruces de Horario",
                          style: CText.primarycustomText(
                              1.7, context, 'CircularStdBook'),
                        ),
                      ),
                      FlutterSwitch(
                        width: _size.width * 0.12,
                        height: 25.0,
                        toggleSize: _size.width * 0.04,
                        value: value.sharedPrepeferencesGetValueIsCruzado(),
                        borderRadius: 30.0,
                        activeColor: MColors.buttonColor(),
                        inactiveColor:
                            MColors.secondaryBackgroundColor(context),
                        padding: _size.width * 0.01,
                        showOnOff: false,
                        onToggle: (val) {
                          value.setCruzadoValue(val);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: MColors.secondaryTextColor(context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        color: MColors.buttonColor(),
                      ),
                      SizedBox(
                        width: _size.width * .02,
                      ),
                      Expanded(
                        child: Text(
                          "Notificaciones como Alarmas",
                          style: CText.primarycustomText(
                              1.7, context, 'CircularStdBook'),
                        ),
                      ),
                      FlutterSwitch(
                        width: _size.width * 0.12,
                        height: 25.0,
                        toggleSize: _size.width * 0.04,
                        value: value.sharedPrepeferencesGetValueIsAlarma(),
                        borderRadius: 30.0,
                        inactiveColor:
                            MColors.secondaryBackgroundColor(context),
                        activeColor: MColors.buttonColor(),
                        padding: _size.width * 0.01,
                        showOnOff: false,
                        onToggle: (val) {
                          value.setCruzadoValueIsAlarma(val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
