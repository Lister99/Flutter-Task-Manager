import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:scheduleapp/models/m_actividad.dart';
import 'package:scheduleapp/models/m_etiqueta.dart';
import 'package:scheduleapp/utils/u_time.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseMain {
  DataBaseMain._();

  static final DataBaseMain db = DataBaseMain._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'TaskManagerDB1.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Etiqueta (id INTEGER PRIMARY KEY AUTOINCREMENT,  nombre TEXT , color TEXT, candelete Integer)");
    await db.execute(
        "CREATE TABLE AgendaPorDia (agendaID INTEGER PRIMARY KEY AUTOINCREMENT,  etiquetaID Integer , timeInit TEXT,timeEnd TEXT,weekDay INTEGER,comentario TEXT, notificar INTEGER,isAlarma INTEGER)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Comer','ffDD3100',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Desplazamiento','ff913D00',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Dormir','ff5677FC',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Entrenamiento','ff1A951E',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Estudios','ff683BB7',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Internet','ff8F3D01',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Lectura','ff009483',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Pausa','ff8F3C02',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Relación','ffDD3100',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Tareas Domésticas','ff8F3C02',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Trabajo','ff683BB7',0)");
    await db.execute(
        "INSERT INTO Etiqueta(nombre,color,candelete) values('Tv','ff8F3C02',0)");
  }

  // #region Etiquetas
  static Future<List<Etiqueta>> obtenerEtiquetas() async {
    final db = await DataBaseMain.db.database;
    final res = await db.query('Etiqueta');
    List<Etiqueta> list =
        res.isNotEmpty ? res.map((c) => Etiqueta.fromJson(c)).toList() : [];
    return list;
  }

  static Future<Etiqueta> obtenerEtiquetabyID(int id) async {
    final db = await DataBaseMain.db.database;
    final res = await db.rawQuery('select * from Etiqueta where id =?', [id]);
    List<Etiqueta> list =
        res.isNotEmpty ? res.map((c) => Etiqueta.fromJson(c)).toList() : [];
    return list.isEmpty ? null : list[0];
  }

  static Future<int> insertEtiqueta(Etiqueta etiqueta) async {
    final db = await DataBaseMain.db.database;
    var raw = await db.insert('Etiqueta', etiqueta.toBD());
    return raw;
  }

  static Future<int> updateEtiqueta(Etiqueta etiqueta) async {
    final db = await DataBaseMain.db.database;
    var raw = await db.update('Etiqueta', etiqueta.toBD(),
        where: "id = ?", whereArgs: [etiqueta.id]);
    return raw;
  }

  static Future<int> deleteEtiqueta(Etiqueta etiqueta) async {
    final db = await DataBaseMain.db.database;
    var raw = await db.delete('Etiqueta', where: 'id = ${etiqueta.id}');
    return raw;
  }

  // #endregion

  Future<int> insertAgendaRecordatorio(Actividad actividad) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into AgendaPorDia (etiquetaID,timeInit,timeEnd,weekDay,comentario,notificar,isAlarma)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          actividad.etiquetaID,
          TimeValidator.getHora(actividad.timeInit),
          TimeValidator.getHora(actividad.timeFinish),
          actividad.weekDay,
          actividad.comentario,
          actividad.notificar,
          actividad.isAlarma
        ]);
    return raw;
  }

  Future<int> updateActividad(Actividad actividad) async {
    final db = await database;
    var raw = await db.update("AgendaPorDia", actividad.toBD(),
        where: 'agendaID = ?', whereArgs: [actividad.id]);
    return raw;
  }

  Future<int> deleteActividad(Actividad actividad) async {
    final db = await database;
    var raw = await db.delete("AgendaPorDia",
        where: 'agendaID = ?', whereArgs: [actividad.id]);
    return raw;
  }

  Future<List<Actividad>> getActividadesByWeekDay(int weekDay) async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM AgendaPorDia WHERE weekday = ?', [weekDay]);
    List<Actividad> list =
        res.isNotEmpty ? res.map((c) => Actividad.fromBD(c)).toList() : [];
    for (var i = 0; i < list.length; i++) {
      final etiqueta = await obtenerEtiquetabyID(list[i].etiquetaID);
      list[i].color = etiqueta.color;
      list[i].etiquetaName = etiqueta.nombre;
    }
    return list;
  }

  Future<List<Actividad>> getActividadesByEtiquetaID(int etiquetaID) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM AgendaPorDia WHERE etiquetaID = ?', [etiquetaID]);
    List<Actividad> list =
        res.isNotEmpty ? res.map((c) => Actividad.fromBD(c)).toList() : [];
    for (var i = 0; i < list.length; i++) {
      final etiqueta = await obtenerEtiquetabyID(list[i].etiquetaID);
      list[i].color = etiqueta.color;
      list[i].etiquetaName = etiqueta.nombre;
    }
    return list;
  }
}
