import 'package:movil/db/table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nanoid/nanoid.dart';

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
  Future<void> initTable(Database db) async {
    await db.transaction((txn) async {
      final empleadoId = nanoid(10);
      await txn.insert(
        'empleado',
        {
          'id': '${empleadoId}',
          'rol': 'SISTEMAS',
          'salario': 3000,
          'nombres': 'DANIEL',
          'apellidoPaterno': 'ACHACOLLO',
          'apellidoMaterno': 'MARCA',
          'nombreCompleto': 'DANIEL ACHACOLLO MARCA',
          'ci': '7288801 OR',
          'direccion': 'Oruro, Zona Norte',
          'telefono': '76144824',
          'correo': 'daniel30acha@gamil.com',
          'createdAt': '${DateTime.now().toString()}',
          'updatedAt': '${DateTime.now().toString()}',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.insert(
        tableName,
        {
          'id': '${nanoid(10)}',
          'id_empleado': '${empleadoId}',
          'username': 'daniel',
          'privilegio': 1,
          'password':
              '\$2a\$05\$rHEWgWmJfCBc2SzwMdq73.zJSxdojW0YqReH0mWOr.DovXr.xwMdy',
          'createdAt': '${DateTime.now().toString()}',
          'updatedAt': '${DateTime.now().toString()}',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.insert('servicio_tipo', {
        'id': '${nanoid(10)}',
        'tipo': 'INSTALACION',
        'descripcion': 'INSTALACION SISTEMA DE CAMARAS ',
        'createdAt': '${DateTime.now().toString()}',
        'updatedAt': '${DateTime.now().toString()}',
      });
      await txn.insert('servicio_tipo', {
        'id': '${nanoid(10)}',
        'tipo': 'MANTENIMIENTO',
        'descripcion':
            'MANTENIMIENTO PREVENTIVO Y CORRECTIVO DE SISTEMA DE CAMARAS DE SEGURIDAD',
        'createdAt': '${DateTime.now().toString()}',
        'updatedAt': '${DateTime.now().toString()}',
      });
    });
  }

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS usuario');
      await txn.execute(createTableQuery);
    });
  }
}
