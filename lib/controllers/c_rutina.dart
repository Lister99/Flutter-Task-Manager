import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduleapp/api/a_db.dart';
import 'package:scheduleapp/api/a_response.dart';
import 'package:scheduleapp/models/m_actividad.dart';
import 'package:scheduleapp/utils/u_notification.dart';

class RutinaProvider with ChangeNotifier {
  NotificationManager notificationManager = NotificationManager();
  int selectedDay = 0;
  List<List<Actividad>> actividadesSemana = List<List<Actividad>>();

  void setDay(int index) {
    selectedDay = index;
    notifyListeners();
  }

  void initData() async {
    actividadesSemana.clear();
    for (var i = 0; i < 7; i++) {
      actividadesSemana.add(new List<Actividad>());
    }
    for (var i = 0; i < 7; i++) {
      final actividades = await DataBaseMain.db.getActividadesByWeekDay(i);

      actividades.sort((a, b) => mayorTiempo(a.timeInit, b.timeInit));
      actividadesSemana[i] = List.from(setHorariosVacios(actividades));
    }

    notifyListeners();
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

  void update() {
    notifyListeners();
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

  int mayorTiempo(TimeOfDay t1, TimeOfDay t2) {
    DateTime h = DateTime.now();
    DateTime x1 = DateTime(h.year, h.month, h.day, t1.hour, t1.minute, 0);
    DateTime x2 = DateTime(h.year, h.month, h.day, t2.hour, t2.minute, 0);
    return x1.difference(x2).inSeconds;
  }

  int proximaActividad(List<Actividad> list) {
    int prox = 0;
    DateTime n = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    for (var i = 0; i < list.length; i++) {
      if (list[i].tipo == 1) {
        final oriInit = dateandTime(DateTime.now(), list[i].timeInit);
        print(oriInit.compareTo(n));
        if (oriInit.compareTo(n) > 0) {
          prox = i;
          return prox;
        }
      }
    }
    return prox;
  }

  DateTime dateandTime(DateTime fecha, TimeOfDay time) {
    return DateTime(fecha.year, fecha.month, fecha.day, time.hour, time.minute);
  }

  Future<Response> addActividad(Actividad actividad, int isCruce) async {
    Response serviceResponse = Response();
    actividad.tipo = 1;
    final x = isCruce == 0 ? await horarioValido(actividad, true) : true;
    if (x) {
      serviceResponse.identifier = 'success';
      serviceResponse.message = "Hora válida";
      final re = await DataBaseMain.db.insertAgendaRecordatorio(actividad);
      if (re > 0) {
        serviceResponse.identifier = 'success';
        serviceResponse.message = "Actividad añadida";
        actividad.id = re;
        final eti =
            await DataBaseMain.obtenerEtiquetabyID(actividad.etiquetaID);
        actividad.etiquetaName = eti.nombre;
        notifyListeners();
        if (actividad.notificar == 1) {
          // if (TimeValidator.dateandTime(DateTime.now(), actividad.timeInit)
          //         .compareTo(DateTime.now()) >
          //0) {
          createRecordatorio(actividad);
          //}
        }
        initData();
      } else {
        serviceResponse.identifier = 'error';
        serviceResponse.message = "No se pudieron guardar los datos";
      }
    } else {
      serviceResponse.identifier = 'error';
      serviceResponse.message = "Hora no válida";
    }

    return serviceResponse;
  }

  Future<Response> updateActividad(Actividad actividad, int isCruce) async {
    Response serviceResponse = Response();
    actividad.tipo = 1;
    final x = isCruce == 0 ? await horarioValido(actividad, true) : true;
    if (x) {
      serviceResponse.identifier = 'success';
      serviceResponse.message = "Hora válida";
      final re = await DataBaseMain.db.updateActividad(actividad);
      if (re > 0) {
        serviceResponse.identifier = 'success';
        serviceResponse.message = "Actividad añadida";
        //actividadesSemana[actividad.weekDay].singleWhere((element) => actividad.id==element.id).update(actividad);
        //actividad.etiquetaName = eti.nombre;
        notifyListeners();
        notificationManager.removeReminder(actividad.id);

        if (actividad.notificar == 1) {
          // if (TimeValidator.dateandTime(DateTime.now(), actividad.timeInit)
          //         .compareTo(DateTime.now()) >
          //0) {
          createRecordatorio(actividad);
          //}
        }
        initData();
      } else {
        serviceResponse.identifier = 'error';
        serviceResponse.message = "No se pudieron guardar los datos";
      }
    } else {
      serviceResponse.identifier = 'error';
      serviceResponse.message = "Hora no válida";
    }

    return serviceResponse;
  }

  Future<Response> deleteActividad(Actividad actividad) async {
    Response serviceResponse = Response();
    actividad.tipo = 1;
    serviceResponse.identifier = 'success';
    serviceResponse.message = "Hora válida";
    final re = await DataBaseMain.db.deleteActividad(actividad);
    if (re > 0) {
      serviceResponse.identifier = 'success';
      serviceResponse.message = "Actividad añadida";
      notificationManager.removeReminder(actividad.id);
      initData();
    } else {
      serviceResponse.identifier = 'error';
      serviceResponse.message = "No se pudieron guardar los datos";
    }
    return serviceResponse;
  }

  createRecordatorio(Actividad actividad) {
    notificationManager.showAlarmDaysInterval(
        actividad.id,
        "Task Manager",
        actividad.etiquetaName,
        actividad.weekDay + 1,
        Time(actividad.timeInit.hour, actividad.timeInit.minute, 0),
        actividad.isAlarma);
  }

  static int getDaysN(int day) {
    switch (day) {
      case 0:
        return 2;
        break;
      case 1:
        return 3;
        break;
      case 2:
        return 4;
        break;
      case 3:
        return 5;
        break;
      case 4:
        return 6;
        break;
      case 5:
        return 7;
        break;
      case 6:
        return 1;
        break;
      default:
        return 1;
        break;
    }
  }

  Future<bool> horarioValido(Actividad actividad, bool usingWeekDay) async {
    bool re = true;
    List<Actividad> actividades = await DataBaseMain.db.getActividadesByWeekDay(
        usingWeekDay ? actividad.weekDay : selectedDay);
    for (var i = 0; i < actividades.length; i++) {
      if (dentrodeunaActividad(actividad, actividades[i])) {
        re = false;
      } else if (contieneunaActividad(actividad, actividades[i])) {
        re = false;
      }
    }
    return re;
  }

  bool dentrodeunaActividad(Actividad nuevo, Actividad original) {
    bool re = false;
    final fecha = DateTime.now();
    final oriIni = dateandTime(fecha, original.timeInit);
    final oriEnd = dateandTime(fecha, original.timeFinish);
    final newInit = dateandTime(fecha, nuevo.timeInit);
    final newEnd = dateandTime(fecha, nuevo.timeFinish);

    if (newInit.difference(oriIni).inMinutes > 0 &&
        oriEnd.difference(newInit).inMinutes > 0) {
      re = true;
    }
    if (newEnd.difference(oriIni).inMinutes > 0 &&
        oriEnd.difference(newEnd).inMinutes > 0) {
      re = true;
    }
    return re;
  }

  bool contieneunaActividad(Actividad nuevo, Actividad original) {
    bool antes = false;
    bool despues = false;
    bool re = false;
    final fecha = DateTime.now();
    final oriIni = dateandTime(fecha, original.timeInit);
    final oriEnd = dateandTime(fecha, original.timeFinish);
    final newInit = dateandTime(fecha, nuevo.timeInit);
    final newEnd = dateandTime(fecha, nuevo.timeFinish);

    if (oriIni.difference(newInit).inMinutes > 0) {
      antes = true;
    }
    if (newEnd.difference(oriEnd).inMinutes > 0) {
      despues = true;
    }
    re = antes && despues ? true : false;
    return re;
  }
}
