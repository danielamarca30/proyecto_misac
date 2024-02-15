import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class ClienteTable extends DatabaseTable {
  @override
  String get tableName => 'cliente';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cliente(
      id TEXT PRIMARY KEY,
      cod_cliente TEXT,
      nombres TEXT,
      apellidoPaterno TEXT,
      apellidoMaterno TEXT,
      nombreCompleto TEXT UNIQUE,
      ci TEXT,
      direccion TEXT,
      ubicacionLat TEXT,
      ubicacionLng TEXT,
      telefono TEXT,
      correo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';
  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cliente');
      await txn.execute(createTableQuery);
    });
  }
}
