import 'package:flutter/widgets.dart';
import 'package:scheduleapp/api/a_db.dart';
import 'package:scheduleapp/api/a_response.dart';
import 'package:scheduleapp/models/m_etiqueta.dart';

class EtiquetaProvider with ChangeNotifier {
  List<Etiqueta> etiquetas = new List<Etiqueta>();

  void obtenerEtiquetas() async {
    final x = await DataBaseMain.obtenerEtiquetas();
    etiquetas = x;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  Future<Response> addEtiqueta(String nombre, Color color) async {
    Response r = Response();
    Etiqueta e = Etiqueta();
    e.nombre = nombre;
    e.color = color;
    final x = await DataBaseMain.insertEtiqueta(e);
    if (x > 0) {
      e.id = x;
      etiquetas.add(e);
      notifyListeners();
      r = Response(identifier: "success", message: "Etiqueta Agregada");
    } else {
      r = Response(identifier: "error", message: "Sucedio un error");
    }
    return r;
  }

  Future<Response> updateEtiqueta(int id, String nombre, Color color) async {
    Response r = Response();
    Etiqueta e = Etiqueta();
    e.nombre = nombre;
    e.color = color;
    e.id = id;
    final x = await DataBaseMain.updateEtiqueta(e);
    if (x > 0) {
      //e.id = x;
      etiquetas.singleWhere((es) => es.id == e.id).nombre = nombre;
      etiquetas.singleWhere((es) => es.id == e.id).color = color;
      notifyListeners();
      r = Response(identifier: "success", message: "Etiqueta Agregada");
    } else {
      r = Response(identifier: "error", message: "Sucedio un error");
    }
    return r;
  }

  Future<Response> deleteEtiqueta(Etiqueta etiqueta) async {
    Response r = Response();
    final list = await DataBaseMain.db.getActividadesByEtiquetaID(etiqueta.id);
    if (list.isNotEmpty) {
      r = Response(identifier: "error", message: "Esta etiqueta esta en uso");
    } else {
      final x = await DataBaseMain.deleteEtiqueta(etiqueta);
      if (x > 0) {
        etiquetas.removeWhere((element) => element.id == etiqueta.id);
        notifyListeners();
        r = Response(identifier: "success", message: "Etiqueta Eliminada");
      } else {
        r = Response(identifier: "error", message: "Sucedio un error");
      }
    }
    return r;
  }
}
