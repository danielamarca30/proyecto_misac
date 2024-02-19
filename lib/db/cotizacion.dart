import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class CotizacionTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion (
      id TEXT PRIMARY KEY,
      id_cliente TEXT REFERENCES cliente(id),
      id_empleado TEXT REFERENCES empleado(id),
      monto REAL,
      estado TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion');
      await txn.execute(createTableQuery);
    });
  }
}

class CotizacionServicioTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion_servicio';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion_servicio (
      id TEXT PRIMARY KEY,
      id_cotizacion TEXT REFERENCES cotizacion(id),
      id_servicio TEXT REFERENCES servicio(id),
      fechaCreacion TEXT,
      fechaValidez TEXT,
      monto REAL,
      estado TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion_servicio');
      await txn.execute(createTableQuery);
    });
  }
}

class CotizacionVentaTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion_venta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion_venta (
      id TEXT PRIMARY KEY,
      id_cotizacion TEXT REFERENCES cotizacion(id),
      id_venta TEXT REFERENCES venta(id),
      fechaCreacion TEXT,
      fechaValidez TEXT,
      monto REAL,
      estado TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion_venta');
      await txn.execute(createTableQuery);
    });
  }
}
