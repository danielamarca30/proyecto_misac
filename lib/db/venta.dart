import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class VentaTable extends DatabaseTable {
  @override
  String get tableName => 'venta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta (
      id TEXT PRIMARY KEY,
      id_cliente TEXT REFERENCES cliente(id),
      id_empleado TEXT REFERENCES empleado(id),
      tipo TEXT,
      estado TEXT,
      fecha TEXT,
      total REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaPagoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_pago';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_pago (
      id TEXT PRIMARY KEY,
      id_venta TEXT REFERENCES venta(id),
      fecha TEXT,
      monto REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_pago');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaEquipoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_equipo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_venta TEXT REFERENCES venta(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaInsumoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_insumo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_insumo (
      id TEXT PRIMARY KEY,
      id_insumo TEXT REFERENCES insumo(id),
      id_venta TEXT REFERENCES venta(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_insumo');
      await txn.execute(createTableQuery);
    });
  }
}
