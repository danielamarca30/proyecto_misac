import 'package:flutter/foundation.dart';
import 'package:movil/db/db.dart';
import 'package:sqflite/sqflite.dart';

//Local
import 'package:movil/modelos/cliente.dart';

class ClienteProvider with ChangeNotifier {
  late final DataBaseManager _db;
  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  // Crear un singleton
  static final ClienteProvider _instance = ClienteProvider._internal();

  factory ClienteProvider() {
    return _instance;
  }

  ClienteProvider._internal() {
    _db = DataBaseManager();
    initializeDatabase();
    getAllClientes();
  }

  Future<void> initializeDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createCliente(Cliente cliente) async {
    var db = await _db.database;
    var response = await db.insert('cliente', cliente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getAllClientes();
  }

  Future<void> updateCliente(Cliente cliente) async {
    var db = await _db.database;
    await db.update('cliente', cliente.toMap(),
        where: 'id = ?', whereArgs: [cliente.id]);
    await getAllClientes();
  }

  Future<void> deleteCliente(String clientId) async {
    var db = await _db.database;
    await db.delete('cliente', where: 'id = ?', whereArgs: [clientId]);
    await getAllClientes();
  }

  Future<void> getAllClientes() async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('cliente');
    _clientes = result.map((map) => Cliente.fromJson(map)).toList();
    notifyListeners(); // Notify listeners after the data is updated
  }

  Future<void> filtrarCliente(String? query) async {
    var db = await _db.database;
    List<Map<String, dynamic>> result = await db.query('cliente');
    List<Cliente> clientesLista =
        result.map((e) => Cliente.fromJson(e)).toList();
    if (query != null && query.isNotEmpty) {
      _clientes = clientesLista
          .where((cliente) => (cliente.nombreCompleto?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      await getAllClientes();
    }
  }

  Future<void> _ensureDatabaseInitialized() async {
    if (_db.database == null) {
      await _db.initializeDatabase();
    }
  }
}
