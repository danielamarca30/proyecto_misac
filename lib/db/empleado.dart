import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class EmpleadoTable extends DatabaseTable {
  @override
  String get tableName => 'empleado';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS empleado(
      id TEXT PRIMARY KEY,
      rol TEXT,
      salario REAL,
      nombres TEXT,
      apellidoPaterno TEXT,
      apellidoMaterno TEXT,
      nombreCompleto TEXT UNIQUE,
      ci TEXT,
      direccion TEXT,
      telefono TEXT,
      correo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS empleado');
      await txn.execute(createTableQuery);
    });
  }
}

class TecnicoTable extends DatabaseTable {
  @override
  String get tableName => 'tecnico';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tecnico(
      id TEXT PRIMARY KEY,
      id_empleado TEXT REFERENCES empleado(id),
      especialidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tecnico');
      await txn.execute(createTableQuery);
    });
  }
}

class ProveedorTable extends DatabaseTable {
  @override
  String get tableName => 'proveedor';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS proveedor (
      id TEXT PRIMARY KEY,
      nombre TEXT UNIQUE,
      descripcion TEXT,
      direccion TEXT,
      contacto TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS proveedor');
      await txn.execute(createTableQuery);
    });
  }
}
