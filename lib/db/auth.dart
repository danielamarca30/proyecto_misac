import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioTable extends DatabaseTable {
  @override
  String get tableName => 'usuario';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS usuario(
      id TEXT PRIMARY KEY,
      id_empleado TEXT REFERENCES empleado(id),
      username TEXT UNIQUE,
      privilegio INTEGER,
      password TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';
  Future<void> createTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('''
    CREATE TABLE IF NOT EXISTS usuario(
      id TEXT PRIMARY KEY,
      id_empleado TEXT REFERENCES empleado(id),
      username TEXT UNIQUE,
      privilegio INTEGER,
      password TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
      await txn.insert(
        tableName,
        {
          'id': '1',
          'id_empleado': '1',
          'username': 'daniel',
          'privilegio': 10,
          'password':
              '\$2a\$05\$rHEWgWmJfCBc2SzwMdq73.zJSxdojW0YqReH0mWOr.DovXr.xwMdy',
          'createdAt': '2024-02-12',
          'updatedAt': '2024-02-12',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS usuario');
      await txn.execute(createTableQuery);
      await txn.insert(
        tableName,
        {
          'id': '1',
          'id_empleado': '1',
          'username': 'daniel',
          'privilegio': 10,
          'password':
              '\$2a\$05\$rHEWgWmJfCBc2SzwMdq73.zJSxdojW0YqReH0mWOr.DovXr.xwMdy',
          'createdAt': '2024-02-12',
          'updatedAt': '2024-02-12',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
