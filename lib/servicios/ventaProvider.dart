import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
//Local
import 'package:movil/modelos/venta.dart';
import 'package:sqflite/sqflite.dart';

class VentaProvider with ChangeNotifier {
  late DataBaseManager _db;
  List<Map<String, dynamic>> _ventas = [];
  List<Map<String, dynamic>> get ventas => _ventas;

  static final VentaProvider _instance = VentaProvider._internal();
  factory VentaProvider() {
    return _instance;
  }
  VentaProvider._internal() {
    _db = DataBaseManager();
    initializedDatabase();
    getAllVentas();
  }
  Future<void> initializedDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createVenta(Venta venta) async {
    var db = await _db.database;
    await db.insert('venta', venta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllVentas();
  }

  Future<void> getAllVentas() async {
    var db = await _db.database;
    var response = await db.query('venta');
    _ventas = response.toList();
    notifyListeners();
  }
  // Future<void> getAllVentas() async {
  // var db = await _db.database;
  // var response = await db.rawQuery('''
  //   SELECT venta.*, cliente.*
  //   FROM venta
  //   LEFT JOIN cliente ON venta.id_cliente = cliente.id
  // ''');

  // _ventas = response.map((ventaWithCliente) {
  //   return {
  //     'venta': Venta.fromMap(ventaWithCliente), // Convertir a objeto Venta
  //     'cliente':
  //         Cliente.fromMap(ventaWithCliente), // Convertir a objeto Cliente
  //   };
  // }).toList();

  // notifyListeners();
  // }
}
