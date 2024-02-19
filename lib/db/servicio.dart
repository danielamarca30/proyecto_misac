import 'package:sqflite/sqflite.dart';
import 'package:nanoid/nanoid.dart';
//Local
import 'package:movil/db/table.dart';

class ServicioTipoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_tipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_tipo (
      id TEXT PRIMARY KEY,
      tipo TEXT UNIQUE,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';
  Future<void> initTable(Database db) async {
    await db.transaction((txn) async {
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
      await txn.execute('DROP TABLE IF EXISTS servicio_tipo');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioTable extends DatabaseTable {
  @override
  String get tableName => 'servicio';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio (
      id TEXT PRIMARY KEY,
      id_servicio_tipo TEXT REFERENCES servicio_tipo(id),
      id_cliente TEXT REFERENCES cliente(id),
      id_tecnico TEXT REFERENCES tecnico(id),
      descripcion TEXT,
      estado TEXT,
      total REAL,
      fechaInicio TEXT,
      fechaFin TEXT,
      fechaProgramada TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioInspeccionTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_inspeccion';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_inspeccion (
      id TEXT PRIMARY KEY,
      id_servicio TEXT REFERENCES servicio(id),
      estado TEXT UNIQUE,
      costo REAL,
      observacion TEXT,
      fechaInspeccion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_inspeccion');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioEquipoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_equipo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_servicio TEXT REFERENCES servicio(id),
      cantidad INTEGER,
      codigo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioHerramientaTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_herramienta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_herramienta (
      id TEXT PRIMARY KEY,
      id_herramienta TEXT REFERENCES herramienta(id),
      id_servicio TEXT REFERENCES servicio(id),
      costo REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_herramienta');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioInsumoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_insumo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_insumo (
      id TEXT PRIMARY KEY,
      id_insumo TEXT REFERENCES insumo(id),
      id_servicio TEXT REFERENCES servicio(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_insumo');
      await txn.execute(createTableQuery);
    });
  }
}

class TareaTable extends DatabaseTable {
  @override
  String get tableName => 'tarea';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tarea (
      id TEXT PRIMARY KEY,
      id_servicio TEXT REFERENCES servicio(id),
      descripcion TEXT,
      estado INTEGER,
      comentarios TEXT,
      costo REAL,
      fechaInicio TEXT,
      fechaFin TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tarea');
      await txn.execute(createTableQuery);
    });
  }
}

class TareaFotoTable extends DatabaseTable {
  @override
  String get tableName => 'tarea_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tarea_foto (
      id TEXT PRIMARY KEY,
      id_tarea TEXT REFERENCES tarea(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tarea_foto');
      await txn.execute(createTableQuery);
    });
  }
}
