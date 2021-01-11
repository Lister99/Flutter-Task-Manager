import 'package:flutter/material.dart';
import 'package:scheduleapp/utils/u_time.dart';

class Actividad with ChangeNotifier {
  int id;
  int etiquetaID;
  TimeOfDay timeInit;
  TimeOfDay timeFinish;
  int weekDay;
  String comentario;
  Color color;
  int notificar;
  int tipo;
  int isAlarma;
  String etiquetaName;

  Actividad();

  factory Actividad.fromBD(Map json) {
    Actividad actividad = Actividad();
    actividad.id = json['agendaID'];
    actividad.etiquetaID = json['etiquetaID'];
    actividad.notificar = json['notificar'];
    actividad.weekDay = json['weekDay'];
    actividad.isAlarma = json['isAlarma'];
    actividad.comentario = json['comentario'];
    actividad.timeInit = TimeValidator.stringToTimeOfDay(json['timeInit']);
    actividad.timeFinish = TimeValidator.stringToTimeOfDay(json['timeEnd']);
    actividad.tipo = 1;
    return actividad;
  }

  Map<String, dynamic> toBD() {
    var map = <String, dynamic>{
      'agendaID': this.id,
      'etiquetaID': this.etiquetaID,
      'notificar': this.notificar,
      'weekDay': this.weekDay,
      'isAlarma': this.isAlarma,
      'comentario': this.comentario,
      'timeInit': TimeValidator.getHora(this.timeInit),
      'timeEnd': TimeValidator.getHora(this.timeFinish),
    };
    return map;
  }

  update(Actividad actividad) {
    this.timeInit = actividad.timeInit;
    this.timeFinish = actividad.timeFinish;
  }

  factory Actividad.clone(Actividad a) {
    Actividad actividad = Actividad();
    actividad.id = a.id;
    actividad.etiquetaID = a.etiquetaID;
    actividad.notificar = a.notificar;
    actividad.weekDay = a.weekDay;
    actividad.isAlarma = a.isAlarma;
    actividad.comentario = a.comentario;
    actividad.timeInit = a.timeInit;
    actividad.timeFinish = a.timeFinish;
    actividad.color = a.color;
    actividad.tipo = 1;
    return actividad;
  }
}
