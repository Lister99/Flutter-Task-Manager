import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/api/a_db.dart';
import 'package:scheduleapp/models/m_actividad.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  int selectedIndex = 0;
  List<Actividad> actividades = List<Actividad>();
  DateTime diaSelected = DateTime.now();
  SharedPreferences sharedPreferences;

  setDay(DateTime x) {
    diaSelected = x;
    notifyListeners();
    initData();
  }

  void update() {
    notifyListeners();
  }

  bool isEmpty() {
    if (DateFormat('yyyy-MM-dd').format(diaSelected) !=
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      return true;
    } else {
      return actividades.isEmpty;
    }
  }

  Future<int> getActivyInProgress() async {
    int rei = 0;
    // List<Actividad> x = List<Actividad>.from(actividades)
    //     .where((element) => element.agendaTipo == 1)
    //     .toList();
    final dy = existeDentro(actividades);
    if (dy['existe']) {
      rei = dy['position'];
    } else {
      rei = proximaActividad(actividades);
    }

    return rei;
  }

  dynamic existeDentro(List<Actividad> list) {
    dynamic re = {"existe": false, "position": 0};
    DateTime n = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    for (var i = 0; i < list.length; i++) {
      if (list[i].tipo == 1) {
        if (dentrodeuno(n, list[i])) {
          re = {"existe": true, "position": i};
        }
      }
    }
    return re;
  }

  bool sharedPrepeferencesGetValueIsCruzado() {
    final x = sharedPreferences.getBool("CrucePermitido");
    return x == null ? false : x;
  }

  void setCruzadoValue(bool e) {
    sharedPreferences.setBool("CrucePermitido", e);
    notifyListeners();
  }

  bool sharedPrepeferencesGetValueIsAlarma() {
    final x = sharedPreferences.getBool("ComoAlarma");
    return x == null ? false : x;
  }

  void setCruzadoValueIsAlarma(bool e) {
    sharedPreferences.setBool("ComoAlarma", e);
    notifyListeners();
  }

  bool dentrodeuno(DateTime n, Actividad original) {
    bool re = false;
    final oriIni = dateandTime(diaSelected, original.timeInit);
    final oriEnd = dateandTime(diaSelected, original.timeFinish);
    final newInit = n;

    if (newInit.difference(oriIni).inMinutes > 0 &&
        oriEnd.difference(newInit).inMinutes > 0) {
      re = true;
    }

    return re;
  }

  int proximaActividad(List<Actividad> list) {
    int prox = 0;
    DateTime n = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    for (var i = 0; i < list.length; i++) {
      if (list[i].tipo == 1) {
        final oriInit = dateandTime(diaSelected, list[i].timeInit);
        print(oriInit.compareTo(n));
        if (oriInit.compareTo(n) > 0) {
          prox = i;
          return prox;
        }
      }
    }
    return prox;
  }

  Future<void> initData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    actividades.clear();
    actividades =
        await DataBaseMain.db.getActividadesByWeekDay(diaSelected.weekday - 1);
    actividades.sort((a, b) => mayorTiempo(a.timeInit, b.timeInit));
    actividades = List.from(setHorariosVacios(actividades));
    notifyListeners();
  }

  int mayorTiempo(TimeOfDay t1, TimeOfDay t2) {
    DateTime h = DateTime.now();
    DateTime x1 = DateTime(h.year, h.month, h.day, t1.hour, t1.minute, 0);
    DateTime x2 = DateTime(h.year, h.month, h.day, t2.hour, t2.minute, 0);
    return x1.difference(x2).inSeconds;
  }

  String minutostoHoras(int minutos) {
    String salida = "";
    if (minutos <= 60) {
      salida = "Tiempo libre $minutos min";
    } else {
      String div = (minutos / 60).toStringAsFixed(2);
      String hora = div.substring(0, div.indexOf('.'));
      String x = div.substring(div.indexOf('.'), div.length);
      int minu = (num.parse(x) * 60).round();
      salida = "Tiempo libre $hora h ${minu == 0 ? "" : "$minu min"}";
    }

    return salida;
  }

  dynamic existeSobraEntreHorariosv2(Actividad prev, Actividad post) {
    dynamic x = {
      'existe': false,
      'diferencia': 0,
    };
    final diferencia = dateandTime(DateTime.now(), prev.timeFinish)
        .difference(dateandTime(DateTime.now(), post.timeFinish))
        .inMinutes;
    if (diferencia > 1) {
      x = {'existe': true, 'diferencia': diferencia};
    }
    return x;
  }

  DateTime dateandTime(DateTime fecha, TimeOfDay time) {
    return DateTime(fecha.year, fecha.month, fecha.day, time.hour, time.minute);
  }

  dynamic existeSobraEntreHorarios(Actividad prev, Actividad post) {
    dynamic x = {
      'existe': false,
      'diferencia': 0,
    };
    final diferencia = dateandTime(DateTime.now(), post.timeInit)
        .difference(dateandTime(DateTime.now(), prev.timeFinish))
        .inMinutes;
    if (diferencia > 1) {
      x = {'existe': true, 'diferencia': diferencia};
    }
    return x;
  }

  List<Actividad> setHorariosVacios(List<Actividad> actividades) {
    List<Actividad> temp = List.of(actividades);

    for (var i = 0; i < temp.length; i++) {
      if (i < (temp.length - 1)) {
        final x = existeSobraEntreHorarios(temp[i], temp[i + 1]);
        if (x['existe']) {
          Actividad ac = Actividad();
          ac.tipo = 2;
          ac.etiquetaName = minutostoHoras(x["diferencia"]);
          temp.insert(i + 1, ac);
          i++;
        }
      }
    }
    if (actividades.length > 0) {
      Actividad ini = Actividad();
      //ini.fecha = temp[0].fecha;
      ini.timeFinish = TimeOfDay(hour: 0, minute: 0);
      final x = existeSobraEntreHorarios(ini, actividades[0]);
      if (x['existe']) {
        Actividad ac = Actividad();
        ac.tipo = 2;
        ac.etiquetaName = minutostoHoras(x["diferencia"]);
        temp.insert(0, ac);
      }
    }
    if (actividades.length > 0) {
      Actividad ini = Actividad();
      //ini.fecha = temp[temp.length - 1].fecha;
      ini.timeFinish = TimeOfDay(hour: 24, minute: 0);
      final x = existeSobraEntreHorariosv2(ini, temp[temp.length - 1]);
      if (x['existe']) {
        Actividad ac = Actividad();
        ac.tipo = 2;
        ac.etiquetaName = minutostoHoras(x["diferencia"]);
        temp.insert(temp.length, ac);
      }
    }
    actividades = List.of(temp);
    return actividades;
  }

  setTabBarIndex(int i) {
    selectedIndex = i;
    notifyListeners();
  }
}
