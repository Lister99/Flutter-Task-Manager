import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeValidator {
  static String timeReamining(DateTime init) {
    String mensaje = "";
    int resta = init.difference(DateTime.now()).inSeconds;
    if (resta > 0) {
      if (resta < 60) {
        mensaje = "Empieza en menos de 1 minuto";
      } else if (resta >= 60 && resta < 3600) {
        mensaje = "Empieza en ${init.difference(DateTime.now()).inMinutes} min";
      } else if (resta >= 3600 && resta < 86400) {
        mensaje = "Empieza en ${_printDuration(Duration(seconds: resta))}";
        // _formatIntervalTime(x.hour, init.hour, x.minute, init.minute)}";
      } else if (resta >= 86400) {
        int diferencia = dayDifferencesWithoutTime(init, DateTime.now());
        mensaje = "Empieza en $diferencia ${diferencia > 1 ? "días" : "día"}";
      }
    } else {
      mensaje =
          "En un momento podrás ingresar a la sala. Gracias por tu paciencia";
    }
    return mensaje;
  }

  static int dayDifferencesWithoutTime(DateTime x, DateTime y) {
    return dateWithoutTime(x).difference(dateWithoutTime(y)).inDays;
  }

  static String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    //String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours} ${duration.inHours > 1 ? 'horas' : 'hora'} $twoDigitMinutes min";
  }

  // static String _formatIntervalTime(
  //     int init, int end, int initmin, int endmin) {
  //   var sleepTime = end > init ? end - init : 23 - init + end; //De 24 a 25
  //   var minutes = endmin > initmin ? endmin - initmin : 60 - initmin + endmin;
  //   var horasd = (minutes > 0 && minutes < 60)
  //       ? (endmin > initmin && init > end)
  //           ? sleepTime + 1
  //           : sleepTime
  //       : sleepTime;
  //   String minu = (minutes == 0 || minutes == 60) ? '' : ' $minutes minutos';
  //   String showHora =
  //       horasd == 0 ? "" : "$horasd hora${horasd == 1 ? "" : "s"}";
  //   return '$showHora$minu';
  // }

  static String needZero(int i) {
    return (i >= 10) ? '$i' : '0$i';
  }

  static DateTime dateWithoutTime(DateTime x) =>
      DateTime(x.year, x.month, x.day);

  static DateTime dateandTime(DateTime fecha, TimeOfDay time) {
    return DateTime(fecha.year, fecha.month, fecha.day, time.hour, time.minute);
  }

  static TimeOfDay timeWithSubtractedMinutes(TimeOfDay time, int minutes) {
    return timefromDate(
        timeWithEmptyDate(time).add(Duration(minutes: -minutes)));
  }

  static DateTime timeWithEmptyDate(TimeOfDay time) {
    return DateTime(2020, 1, 2, time.hour, time.minute);
  }

  static TimeOfDay timefromDate(DateTime x) {
    return TimeOfDay(hour: x.hour, minute: x.minute);
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.Hms(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static DateTime stringtoDate(String s) {
    return DateFormat('yyyy-MM-dd').parse(s);
  }

  static int weekDifference(DateTime a, DateTime b) {
    int difference = a.compareTo(b);
    DateTime mayor = difference > 0 ? a : b;
    DateTime menor = difference > 0 ? b : a;
    int weekDayMayor = mayor.weekday;
    int weekDayMenor = menor.weekday;
    mayor = mayor.add(Duration(days: 7 - weekDayMayor));
    menor = menor.add(Duration(days: -(weekDayMenor)));
    final differenceWeek = (mayor.difference(menor).inDays / 7).round();
    return differenceWeek;
  }

  static String dateToString(DateTime x) => DateFormat('yyyy-MM-dd').format(x);

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return "Enero";
        break;
      case 2:
        return "Febrero";
        break;
      case 3:
        return "Marzo";
        break;
      case 4:
        return "Abril";
        break;
      case 5:
        return "Mayo";
        break;
      case 6:
        return "Junio";
        break;
      case 7:
        return "Julio";
        break;
      case 8:
        return "Agosto";
        break;
      case 9:
        return "Septiembre";
        break;
      case 10:
        return "Octubre";
        break;
      case 11:
        return "Noviembre";
        break;
      case 12:
        return "Diciembre";
        break;
      default:
        return "Mes";
        break;
    }
  }

  static String getMonthAbrevation3Letters(number) {
    String labelMonth = "";
    switch (number) {
      case 1:
        labelMonth = "Ene";
        break;
      case 2:
        labelMonth = "Feb";
        break;
      case 3:
        labelMonth = "Marz";
        break;
      case 4:
        labelMonth = "Abri";
        break;
      case 5:
        labelMonth = "Mayo";
        break;
      case 6:
        labelMonth = "Jun";
        break;
      case 7:
        labelMonth = "Jul";
        break;
      case 8:
        labelMonth = "Ago";
        break;
      case 9:
        labelMonth = "Sep";
        break;
      case 10:
        labelMonth = "Oct";
        break;
      case 11:
        labelMonth = "Nov";
        break;
      case 12:
        labelMonth = "Dom";
        break;
    }
    return labelMonth;
  }

  static int getDaysV2(String day) {
    switch (day) {
      case 'Lu':
        return 2;
        break;
      case 'Ma':
        return 3;
        break;
      case 'Mi':
        return 4;
        break;
      case 'Ju':
        return 5;
        break;
      case 'Vi':
        return 6;
        break;
      case 'Sa':
        return 7;
        break;
      case 'Do':
        return 1;
        break;
      default:
        return 1;
        break;
    }
  }

  static int getDaysV3(String day) {
    switch (day) {
      case 'Lu':
        return 1;
        break;
      case 'Ma':
        return 2;
        break;
      case 'Mi':
        return 3;
        break;
      case 'Ju':
        return 4;
        break;
      case 'Vi':
        return 5;
        break;
      case 'Sa':
        return 6;
        break;
      case 'Do':
        return 7;
        break;
      default:
        return 1;
        break;
    }
  }

  static String getDaysS(int day) {
    switch (day) {
      case 1:
        return 'Lu';
        break;
      case 2:
        return 'Ma';
        break;
      case 3:
        return 'Mi';
        break;
      case 4:
        return 'Ju';
        break;
      case 5:
        return 'Vi';
        break;
      case 6:
        return 'Sa';
        break;
      case 7:
        return 'Do';
        break;
      default:
        return 'Lu';
        break;
    }
  }

  static String getDaysC(int day) {
    switch (day) {
      case 1:
        return 'Lunes';
        break;
      case 2:
        return 'Martes';
        break;
      case 3:
        return 'Miércoles';
        break;
      case 4:
        return 'Jueves';
        break;
      case 5:
        return 'Viernes';
        break;
      case 6:
        return 'Sábado';
        break;
      case 7:
        return 'Domingo';
        break;
      default:
        return 'Lunes';
        break;
    }
  }

  static int getDaysN(String day) {
    switch (day) {
      case 'Lu':
        return 2;
        break;
      case 'Ma':
        return 3;
        break;
      case 'Mi':
        return 4;
        break;
      case 'Ju':
        return 5;
        break;
      case 'Vi':
        return 6;
        break;
      case 'Sa':
        return 7;
        break;
      case 'Do':
        return 1;
        break;
      default:
        return 1;
        break;
    }
  }

  static String getDayAbrevation3Letters(number) {
    String labelDate = "";
    switch (number) {
      case 1:
        labelDate = "Lun";
        break;
      case 2:
        labelDate = "Mar";
        break;
      case 3:
        labelDate = "Mier";
        break;
      case 4:
        labelDate = "Juev";
        break;
      case 5:
        labelDate = "Vier";
        break;
      case 6:
        labelDate = "Sab";
        break;
      case 7:
        labelDate = "Dom";
        break;
    }
    return labelDate;
  }

  static bool dayPass(String fechax, String fechaActual) {
    bool re = false;
    if (fechax == fechaActual) {
      re = true;
    }
    return re;
  }

  static String getHora(TimeOfDay hora) {
    return '${needZero(hora.hour)}:${needZero(hora.minute)}:00';
  }

  static String getTime(DateTime x) {
    return '${needZero(x.hour)}:${needZero(x.minute)}';
  }

  static String getTimeOfDayS(TimeOfDay x) {
    return '${needZero(x.hour)}:${needZero(x.minute)}';
  }

  static String getDateAbrevation(number) {
    String labelDate = "";
    switch (number) {
      case 1:
        labelDate = "Enero";
        break;
      case 2:
        labelDate = "Febrero";
        break;
      case 3:
        labelDate = "Marzo";
        break;
      case 4:
        labelDate = "Abril";
        break;
      case 5:
        labelDate = "Mayo";
        break;
      case 6:
        labelDate = "Junio";
        break;
      case 7:
        labelDate = "Julio";
        break;
      case 8:
        labelDate = "Agosto";
        break;
      case 9:
        labelDate = "Septiembre";
        break;
      case 10:
        labelDate = "Octubre";
        break;
      case 11:
        labelDate = "Noviembre";
        break;
      case 12:
        labelDate = "Diciembre";
        break;
    }
    return labelDate;
  }

  static String getDaysStr(int day) {
    switch (day) {
      case 2:
        return 'Lu';
        break;
      case 3:
        return 'Ma';
        break;
      case 4:
        return 'Mi';
        break;
      case 5:
        return 'Ju';
        break;
      case 6:
        return 'Vi';
        break;
      case 7:
        return 'Sa';
        break;
      case 1:
        return 'Do';
        break;
      default:
        return 'Do';
        break;
    }
  }

  static bool timePass(DateTime now, DateTime x) {
    bool re = false;
    DateTime no2 =
        DateTime(now.year, now.month, now.day, now.hour, now.minute, 0);
    print('Diferencia ${x.difference(no2).inMinutes}');
    if (x.difference(no2).inMinutes >= 0) {
      re = true;
    }
    return re;
  }

  static String passslashtoguide(String fecha) {
    DateTime d = DateFormat('dd/MM/yyyy').parse(fecha);
    return DateFormat('yyyy-MM-dd').format(d);
  }
}
