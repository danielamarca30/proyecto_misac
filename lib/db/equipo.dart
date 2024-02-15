import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class EquipoCategoriaTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_categoria';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_categoria (
      id TEXT PRIMARY KEY,
      nombre TEXT UNIQUE,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_categoria');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo(
      id TEXT PRIMARY KEY,
      id_proveedor TEXT,
      id_equipo_categoria TEXT,
      nombre TEXT,
      descripcion TEXT,
      precio REAL,
      stock INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoCodigoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_codigo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_codigo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_servicio TEXT,
      id_venta TEXT,
      codigo TEXT,
      estado TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_codigo');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoFotoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_foto (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_foto');
      await txn.execute(createTableQuery);
    });
  }
}
