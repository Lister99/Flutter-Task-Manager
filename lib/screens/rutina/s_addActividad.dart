import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/controllers/c_home.dart';
import 'package:scheduleapp/controllers/c_rutina.dart';
import 'package:scheduleapp/models/m_actividad.dart';
import 'package:scheduleapp/models/m_etiqueta.dart';
import 'package:scheduleapp/utils/u_color.dart';
import 'package:scheduleapp/utils/u_time.dart';
import 'package:scheduleapp/widgets/w_customSwitch.dart';
import 'package:scheduleapp/widgets/w_customTimePicker.dart';
import 'package:scheduleapp/widgets/w_snackBar.dart';
import 'package:scheduleapp/widgets/w_text.dart';
import 'package:scheduleapp/widgets/w_textField.dart';

// ignore: must_be_immutable
class AddActividad extends StatefulWidget {
  bool isEdit;
  Actividad actividad;
  AddActividad({Key key, this.isEdit = false, this.actividad})
      : super(key: key);

  @override
  _AddActividadState createState() => _AddActividadState();
}

class _AddActividadState extends State<AddActividad> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _horaIni = TextEditingController();
  TextEditingController _horaFin = TextEditingController();
  TextEditingController _comentario = TextEditingController();
  Actividad actividad = Actividad();
  bool _permitirCruce = false;
  Etiqueta e;
  @override
  void initState() {
    if (!widget.isEdit) {
      actividad.timeInit = TimeOfDay.now();
      actividad.timeFinish = TimeOfDay(
          hour: actividad.timeInit.hour, minute: actividad.timeInit.minute + 1);
    } else {
      actividad.id = widget.actividad.id;
      actividad.timeInit = widget.actividad.timeFinish;
      actividad.timeFinish = widget.actividad.timeFinish;
      actividad.isAlarma = widget.actividad.isAlarma;
      actividad.notificar = widget.actividad.notificar;
      actividad.comentario = widget.actividad.comentario;
      e = Etiqueta();
      e.id = widget.actividad.etiquetaID;
      e.nombre = widget.actividad.etiquetaName;
      e.color = widget.actividad.color;
      diaSelected = widget.actividad.weekDay;
      diaString = dias[diaSelected];
      _horaIni.text =
          "${TimeValidator.needZero(actividad.timeInit.hour)}:${TimeValidator.needZero(actividad.timeInit.minute)} ${actividad.timeInit.hour > 11 ? 'PM' : 'AM'}";
      _horaFin.text =
          "${TimeValidator.needZero(actividad.timeFinish.hour)}:${TimeValidator.needZero(actividad.timeFinish.minute)} ${actividad.timeFinish.hour > 11 ? 'PM' : 'AM'}";
    }
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _permitirCruce = Provider.of<HomeProvider>(context, listen: false)
        .sharedPrepeferencesGetValueIsCruzado();
    setState(() {});
  }

  int diaSelected = 0;
  String diaString = "Lunes";

  List<String> dias = [
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado",
    "Domingo"
  ];
  BuildContext myScaContext;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<RutinaProvider>(builder: (context, value, _) {
      return Scaffold(
        backgroundColor: MColors.backgroundColor(context),
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: MColors.backgroundColor(context),
          elevation: 0,
          centerTitle: false,
          iconTheme: Theme.of(context).iconTheme,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
          actions: [
            if (widget.isEdit)
              IconButton(
                onPressed: () async {
                  final x = await value.deleteActividad(actividad);
                  if (x.identifier == "success") {
                    Navigator.pop(context);
                  } else {
                    SnackBars.showErrorSnackBar(
                        myScaContext, context, Icons.error, "Error", x.message);
                  }
                },
                icon: Icon(Icons.delete),
              ),
            IconButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (e == null) {
                    SnackBars.showErrorSnackBar(
                        myScaContext,
                        context,
                        Icons.error,
                        "Etiqueta",
                        "Debe seleccionar una etiqueta");
                    return;
                  }
                  actividad.weekDay = diaSelected;
                  actividad.notificar = 1;
                  actividad.etiquetaID = e.id;
                  actividad.comentario = _comentario.text;
                  actividad.isAlarma =
                      Provider.of<HomeProvider>(context, listen: false)
                              .sharedPrepeferencesGetValueIsAlarma()
                          ? 1
                          : 0;
                  final isCruce = _permitirCruce ? 1 : 0;
                  final x = await (widget.isEdit
                      ? value.updateActividad(actividad, isCruce)
                      : value.addActividad(actividad, isCruce));
                  if (x.identifier == "success") {
                    Navigator.pop(context);
                  } else {
                    SnackBars.showErrorSnackBar(
                        myScaContext, context, Icons.error, "Error", x.message);
                  }
                }
              },
              icon: Icon(Icons.check),
            ),
          ],
          title: Text(
            "${widget.isEdit ? "Editar" : "Nueva"} Actividad",
            style: CText.primarycustomText(2.5, context, "CircularStdBold"),
          ),
        ),
        body: Builder(builder: (scaContezt) {
          myScaContext = scaContezt;
          return SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: _size.width * .05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: MColors.secondaryBackgroundColor(context)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _size.width * .04),
                          child: DropdownButton<String>(
                              value: diaString,
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: 20,
                              elevation: 0,
                              dropdownColor:
                                  MColors.secondaryBackgroundColor(context),
                              isExpanded: true,
                              style: CText.primarycustomText(
                                  1.9, context, "CircularStdMedium"),
                              underline: Container(
                                height: 1,
                                color: Colors.transparent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  diaString = newValue;
                                  diaSelected = dias.indexOf(newValue);
                                });
                              },
                              items: dias.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                showCustomTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        primaryColor: Colors.black,
                                        accentColor: MColors.buttonColor(),
                                      ),
                                      child: child,
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    if (value != null) {
                                      actividad.timeInit = value;
                                      _horaIni.text =
                                          "${TimeValidator.needZero(actividad.timeInit.hour)}:${TimeValidator.needZero(actividad.timeInit.minute)} ${actividad.timeInit.hour > 11 ? 'PM' : 'AM'}";
                                    }
                                  }
                                });
                                // await showDialog(
                                //     context: context,
                                //     builder: (_) {
                                //       return DialogTimePicker(
                                //         initialTime: TimeOfDay.now(),
                                //         isDark: true,
                                //       );
                                //     }).then((value) {
                                //   if (value != null) {
                                //     actividad.timeInit = value;
                                //     _horaIni.text =
                                //         "${TimeValidator.needZero(actividad.timeInit.hour)}:${TimeValidator.needZero(actividad.timeInit.minute)} ${actividad.timeInit.hour > 11 ? 'PM' : 'AM'}";
                                //   }
                                // });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: CTextField(
                                      label: "Hora Inicio",
                                      radius: 5,
                                      controller: _horaIni,
                                      validator: (e) => e.isEmpty
                                          ? 'No puede estar vacio'
                                          : null,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: _size.width * .02)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: _size.width * .04),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    showCustomTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            primaryColor: Colors.black,
                                            accentColor: MColors.buttonColor(),
                                          ),
                                          child: child,
                                        );
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        if (value != null) {
                                          actividad.timeFinish = value;
                                          _horaFin.text =
                                              "${TimeValidator.needZero(actividad.timeFinish.hour)}:${TimeValidator.needZero(actividad.timeFinish.minute)} ${actividad.timeFinish.hour > 11 ? 'PM' : 'AM'}";
                                        }
                                      }
                                    });
                                    // await showDialog(
                                    //     context: context,
                                    //     builder: (_) {
                                    //       return DialogTimePicker(
                                    //         initialTime: TimeOfDay.now(),
                                    //         isDark: true,
                                    //       );
                                    //     }).then((value) {
                                    //   if (value != null) {
                                    //     actividad.timeFinish = value;
                                    //     _horaFin.text =
                                    //         "${TimeValidator.needZero(actividad.timeFinish.hour)}:${TimeValidator.needZero(actividad.timeFinish.minute)} ${actividad.timeFinish.hour > 11 ? 'PM' : 'AM'}";
                                    //   }
                                    // });
                                  },
                                  child: Container(
                                      color: Colors.transparent,
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: CTextField(
                                            label: "Hora Fin",
                                            controller: _horaFin,
                                            radius: 5,
                                            validator: (e) => e.isEmpty
                                                ? 'No puede estar vacio'
                                                : null,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: _size.width * .02)),
                                      )))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CTextField(
                          label: "Comentario",
                          controller: _comentario,
                          radius: 5,
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: _size.width * .02)),
                      SizedBox(
                        height: 20,
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
                              inactiveColor:
                                  MColors.secondaryBackgroundColor(context),
                              toggleSize: _size.width * 0.04,
                              value: _permitirCruce,
                              borderRadius: 30.0,
                              activeColor: MColors.buttonColor(),
                              padding: _size.width * 0.01,
                              showOnOff: false,
                              onToggle: (val) {
                                _permitirCruce = val;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Etiqueta",
                        style: CText.primarycustomText(
                            1.8, context, "CircularStdMedium"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      e == null
                          ? Container(
                              decoration: BoxDecoration(
                                  color:
                                      MColors.secondaryBackgroundColor(context),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _size.width * .05,
                                    vertical: 10),
                                child: Text(
                                  'Seleccione una etiqueta',
                                  style: CText.menucustomText(
                                      1.9, context, "CircularStdBook"),
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: e.color,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: _size.width * .05,
                                        vertical: 10),
                                    child: Text(
                                      e.nombre,
                                      style: CText.menucustomText(
                                          1.9, context, "CircularStdBook"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _size.width * .03,
                                ),
                                if (e != null)
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      e = null;
                                      setState(() {});
                                    },
                                  )
                              ],
                            ),
                      if (e == null)
                        SizedBox(
                          height: 20,
                        ),
                      if (e == null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                e = Provider.of<EtiquetaProvider>(context,
                                        listen: false)
                                    .etiquetas[index];
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: _size.width * .0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Provider.of<EtiquetaProvider>(
                                                  context,
                                                  listen: false)
                                              .etiquetas[index]
                                              .color,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: _size.width * .05,
                                            vertical: 10),
                                        child: Text(
                                          Provider.of<EtiquetaProvider>(context,
                                                  listen: false)
                                              .etiquetas[index]
                                              .nombre,
                                          style: CText.menucustomText(
                                              1.9, context, "CircularStdBook"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: Provider.of<EtiquetaProvider>(context,
                                  listen: false)
                              .etiquetas
                              .length,
                        ),
                    ],
                  ),
                )),
          );
        }),
      );
    });
  }
}
