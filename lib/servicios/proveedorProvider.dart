import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
//Local
import 'package:movil/modelos/equipo.dart';
import 'package:sqflite/sqflite.dart';

class ProveedorProvider with ChangeNotifier {
  late final DataBaseManager _db;
  List<Proveedor> _proveedores = [];
  List<Proveedor> get proveedores => _proveedores;
  static final ProveedorProvider _instance = ProveedorProvider._internal();
  factory ProveedorProvider() {
    return _instance;
  }
  ProveedorProvider._internal() {
    _db = DataBaseManager();
    initializedDatabase();
  }
  Future<void> initializedDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createProveedor(Proveedor proveedor) async {
    var db = await _db.database;
    await db.insert('proveedor', proveedor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllProveedores();
  }

  Future<void> getAllProveedores() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('proveedor');
    _proveedores = result.map((map) => Proveedor.fromJson(map)).toList();
    notifyListeners();
  }

  Future<void> filtrarProveedor(String? query) async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('proveedor');
    List<Proveedor> proveedoresLista =
        result.map((e) => Proveedor.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      _proveedores = proveedoresLista
          .where((proveedor) => (proveedor.nombre?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      await getAllProveedores();
    }
  }
}
