import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
//Local
import 'package:movil/modelos/servicio.dart';

class ServicioProvider with ChangeNotifier {
  late final DataBaseManager _db;
  List<Map<String, dynamic>> _servicios = [];
  List<Map<String, dynamic>> get servicios => _servicios;
  Map<String, dynamic> _servicioDetalle = {};
  Map<String, dynamic> get servicioDetalle => _servicioDetalle;

  List<ServicioTipo> _servicioTipo = [];
  List<ServicioTipo> get servicioTipo => _servicioTipo;

  static final ServicioProvider _instance = ServicioProvider._internal();
  factory ServicioProvider() {
    return _instance;
  }
  ServicioProvider._internal() {
    _db = DataBaseManager();
  }
  Future<void> getAllServicios() async {
    var db = await _db.database;
    List<Map<String, dynamic>> response = await db.query('servicio');
    _servicios = response;
  }

  Future<void> getAllServicioTipos() async {
    var db = await _db.database;
    var response = await db.query('servicio_tipo');
    _servicioTipo =
        response.map((result) => ServicioTipo.fromJson(result)).toList();
  }

  Future<void> insertServicio() async {}
}
