import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
//Local
import 'package:movil/modelos/equipo.dart';
import 'package:sqflite/sqflite.dart';

class EquipoProvider with ChangeNotifier {
  late final DataBaseManager _db;
  List<Equipo> _equipos = [];
  List<Equipo> get equipos => _equipos;
  List<EquipoCategoria> _equipoCategorias = [];
  List<EquipoCategoria> get equipoCategorias => _equipoCategorias;
  List<EquipoFoto> _equipoFotos = [];
  List<EquipoFoto> get equipoFotos => _equipoFotos;
  static final EquipoProvider _instance = EquipoProvider._internal();
  factory EquipoProvider() {
    return _instance;
  }
  EquipoProvider._internal() {
    _db = DataBaseManager();
    initializedDatabase();
    getAllEquipos();
    getAllEquipoCategorias();
    getAllEquipoFotos();
  }
  Future<void> initializedDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createEquipoCategoria(EquipoCategoria equipoCategoria) async {
    var db = await _db.database;
    await db.insert('equipo_categoria', equipoCategoria.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllEquipoCategorias();
  }

  Future<void> createEquipo(Equipo equipo) async {
    var db = await _db.database;
    await db.insert('equipo', equipo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllEquipos();
  }

  Future<void> createEquipoFoto(EquipoFoto equipofoto) async {
    var db = await _db.database;
    await db.insert('equipo_foto', equipofoto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllEquipoFotos();
  }

  Future<void> updateEquipo(Equipo equipo) async {
    var db = await _db.database;
    await db.update('equipo', equipo.toMap(),
        where: 'id = ?', whereArgs: [equipo.id]);
    await getAllEquipos();
  }

  Future<void> deleteEquipo(String equipoId) async {
    var db = await _db.database;
    await db.delete('equipo', where: 'id = ?', whereArgs: [equipoId]);
    await getAllEquipos();
  }

  Future<void> getAllEquipos() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('equipo');
    _equipos = result.map((map) => Equipo.fromJson(map)).toList();
    notifyListeners();
  }

  Future<void> getAllEquipoCategorias() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('equipo_categoria');
    _equipoCategorias =
        result.map((map) => EquipoCategoria.fromJson(map)).toList();
    notifyListeners();
  }

  Future<void> getAllEquipoFotos() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('equipo_foto');
    _equipoFotos = result.map((map) => EquipoFoto.fromJson(map)).toList();
    notifyListeners();
  }

  Future<EquipoFoto?> getEquipoFotoById(String id) async {
    try {
      var db = await _db.database;
      List<Map<String, dynamic>> result = await db
          .query('equipo_foto', where: 'id_equipo = ?', whereArgs: [id]);

      if (result.isNotEmpty) {
        return EquipoFoto.fromJson(result.first);
      } else {
        // Si no se encuentra ninguna foto con el ID proporcionado, puedes manejar el caso devolviendo null o lanzando una excepción, según tus necesidades.
        // return null;
        throw Exception(
            "No se encontró ninguna foto de equipo con el ID proporcionado: $id");
      }
    } catch (e) {
      // Manejar errores de manera adecuada según tus necesidades
      print("Error al obtener la foto del equipo: $e");
      rethrow; // Esto relanza la excepción para que pueda ser manejada en niveles superiores si es necesario.
    }
  }

  Future<void> filtrarEquipo(String? query) async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('equipo');
    List<Equipo> equiposLista = result.map((e) => Equipo.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      _equipos = equiposLista
          .where((equipo) => (equipo.nombre?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      await getAllEquipos();
    }
  }

  Future<void> filtrarEquipoCaterogia(String? query) async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('equipo_categoria');
    List<Equipo> equipoCategoriasLista =
        result.map((e) => Equipo.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      _equipos = equipoCategoriasLista
          .where((equipoCategoria) =>
              (equipoCategoria.nombre?.toLowerCase() ?? "")
                  .contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      await getAllEquipos();
    }
  }
}
