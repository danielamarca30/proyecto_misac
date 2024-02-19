import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
import 'package:movil/modelos/empleado.dart';
import 'package:sqflite/sqflite.dart';

class EmpleadoProvider with ChangeNotifier {
  late final DataBaseManager _db;
  List<Empleado> _empleados = [];
  List<Empleado> get empleados => _empleados;

  List<TecnicoDetalle> _tecnicos = [];
  List<TecnicoDetalle> get tecnicos => _tecnicos;

  static final EmpleadoProvider _instance = EmpleadoProvider._internal();
  factory EmpleadoProvider() {
    return _instance;
  }
  EmpleadoProvider._internal() {
    _db = DataBaseManager();
    initializeDatabase();
    getAllEmpleados();
  }
  Future<void> initializeDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createTecnico(Tecnico tecnico) async {
    var db = await _db.database;
    await db.insert('tecnico', tecnico.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllTecnicos();
  }

  Future<void> createEmpleado(Empleado empleado) async {
    var db = await _db.database;
    await db.insert('empleado', empleado.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllEmpleados();
  }

  Future<void> getAllEmpleados() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('empleado');
    _empleados = result.map((empleado) => Empleado.fromJson(empleado)).toList();
    notifyListeners();
  }

  Future<void> getAllTecnicos() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT
  tecnico.id AS id,
  tecnico.id_empleado AS id_empleado_id,
  tecnico.especialidad AS especialidad,
  tecnico.createdAt AS createdAt,
  tecnico.updatedAt AS updatedAt,
  empleado.id AS empleado_id,
  empleado.rol AS empleado_rol,
  empleado.salario AS empleado_salario,
  empleado.nombres AS empleado_nombres,
  empleado.apellidoPaterno AS empleado_apellido_paterno,
  empleado.apellidoMaterno AS empleado_apellido_materno,
  empleado.nombreCompleto AS empleado_nombreCompleto,
  empleado.ci AS empleado_ci,
  empleado.direccion AS empleado_direccion,
  empleado.telefono AS empleado_telefono,
  empleado.correo AS empleado_correo,
  empleado.createdAt AS empleado_createdAt,
  empleado.updatedAt AS empleado_updatedAt
  FROM tecnico AS tecnico
  LEFT JOIN empleado ON tecnico.id_empleado=empleado.id
''');
    _tecnicos = result
        .map((tecnico) => TecnicoDetalle.fromMapDetalle(tecnico))
        .toList();
    notifyListeners();
  }

  Future<void> updateEmpleado(Empleado empleado) async {
    var db = await _db.database;
    await db.update("empleado", empleado.toMap(),
        where: "id = ?", whereArgs: [empleado.id]);
    await getAllEmpleados();
  }

  Future<void> updateTecnico(Empleado tecnico) async {
    var db = await _db.database;
    await db.update("tecnico", tecnico.toMap(),
        where: "id = ?", whereArgs: [tecnico.id]);
    await getAllTecnicos();
  }

  Future<Tecnico> getTecnicoById(String empleadoId) async {
    try {
      var db = await _db.database;
      List<Map<String, dynamic>> result = await db
          .query('tecnico', where: 'id_empleado = ?', whereArgs: [empleadoId]);
      if (result.isNotEmpty) {
        return Tecnico.fromJson(result.first);
      } else {
        throw Exception(
            "No se encontró ninguna foto de equipo con el ID proporcionado: $empleadoId");
      }
    } catch (e) {
      rethrow; // Esto relanza la excepción para que pueda ser manejada en niveles superiores si es necesario.
    }
  }

  Future<void> deleteEmpleado(String empleadoId) async {
    var db = await _db.database;
    await db.delete("empleado", where: "id = ?", whereArgs: [empleadoId]);
    await db
        .delete("tecnico", where: "id_empleado = ?", whereArgs: [empleadoId]);
    await getAllEmpleados();
  }

  Future<void> deleteTecnico(String tecnicoId) async {
    var db = await _db.database;
    await db.delete("tecnico", where: "id = ?", whereArgs: [tecnicoId]);
    await getAllTecnicos();
  }
}
