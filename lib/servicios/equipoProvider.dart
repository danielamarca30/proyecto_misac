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

//Detalle
  List<EquipoDetalle> _equipoDetalle = [];
  List<EquipoDetalle> get equipoDetalle => _equipoDetalle;

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
    getAllEquipoDetalles();
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

  Future<void> getAllEquipoDetalles() async {
    var db = await _db.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT
      equipo.id AS id,
      equipo.id_proveedor AS id_proveedor_id,
      proveedor.nombre AS id_proveedor_nombre,
      proveedor.descripcion AS id_proveedor_descripcion,
      equipo.id_equipo_categoria AS id_equipo_categoria,
      equipo.nombre AS nombre,
      equipo.descripcion AS descripcion,
      equipo.stock AS stock,
      equipo.precio AS precio,
      equipo.createdAt AS createdAt,
      equipo.updatedAt AS updatedAt,
      proveedor.id AS proveedors_id,
      proveedor.nombre AS proveedors_nombre,
      proveedor.descripcion AS proveedors_descripcion,
      proveedor.direccion AS proveedors_direccion,
      proveedor.contacto AS proveedors_contacto,
      proveedor.createdAt AS proveedors_createdAt,
      proveedor.updatedAt AS proveedors_updatedAt,
      equipo_categoria.id AS equipoCategorias_id,
      equipo_categoria.nombre AS equipoCategorias_nombre,
      equipo_categoria.descripcion AS equipoCategorias_descripcion,
      equipo_categoria.createdAt AS equipoCategorias_createdAt,
      equipo_categoria.updatedAt AS equipoCategorias_updatedAt,
      equipo_foto.id AS equipoFoto_id,
      equipo_foto.id_equipo AS equipoFoto_id_equipo,
      equipo_foto.archivoUrl AS equipoFoto_archivoUrl,
      equipo_foto.formato AS equipoFoto_formato,
      equipo_foto.descripcion AS equipoFoto_descripcion,
      equipo_foto.createdAt AS equipoFoto_createdAt,
      equipo_foto.updatedAt AS equipoFoto_updatedAt
    FROM equipo AS equipo
    LEFT JOIN proveedor ON equipo.id_proveedor = proveedor.id
    LEFT JOIN equipo_categoria ON equipo.id_equipo_categoria = equipo_categoria.id
    LEFT JOIN equipo_foto ON equipo.id = equipo_foto.id_equipo
  ''');
    _equipoDetalle = result.map((map) => EquipoDetalle.fromMap(map)).toList();
    notifyListeners();
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
