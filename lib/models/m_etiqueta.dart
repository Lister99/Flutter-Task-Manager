import 'package:flutter/material.dart';
import 'package:scheduleapp/utils/u_colorHex.dart';

class Etiqueta {
  int id;
  String nombre;
  Color color;
  int canDelete;

  Etiqueta();

  factory Etiqueta.fromJson(Map<String, dynamic> json) {
    Etiqueta e = new Etiqueta();
    e.id = json["id"];
    e.nombre = json["nombre"];
    e.color = HexColor(json["color"]);
    e.canDelete = json["candelete"];
    return e;
  }

  Map<String, dynamic> toBD() {
    var map = <String, dynamic>{
      'id': this.id,
      'color': HexColorMaterial.colorToHext(this.color),
      'nombre': this.nombre,
      'candelete': 1,
    };
    return map;
  }
}
