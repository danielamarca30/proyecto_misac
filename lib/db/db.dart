import 'package:movil/db/cotizacion.dart';
import 'package:movil/db/equipo.dart';
import 'package:movil/db/servicio.dart';
import 'package:movil/db/venta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movil/db/table.dart';

// Importar las tablas;
import 'package:movil/db/empleado.dart';
import 'package:movil/db/auth.dart';
import 'package:movil/db/cliente.dart';

class SyncLocalTable extends DatabaseTable {
  @override
  String get tableName => 'synclocal';

  @override
  String get createTableQuery => '''
   CREATE TABLE IF NOT EXISTS synclocal(
      id INTEGER PRIMARY KEY,
      tabla TEXT,
      action TEXT,
      id_tabla TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS synclocal');
      await txn.execute(createTableQuery);
    });
  }
}

class SyncServerTable extends DatabaseTable {
  @override
  String get tableName => 'syncserver';

  @override
  String get createTableQuery => '''
   CREATE TABLE IF NOT EXISTS syncserver(
      id INTEGER PRIMARY KEY,
      tabla TEXT,
      action TEXT,
      id_tabla TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS syncserver');
      await txn.execute(createTableQuery);
    });
  }
}

class DataBaseManager {
  late Database _database;
  late List<DatabaseTable> tables = [
    SyncLocalTable(),
    SyncServerTable(),
    EmpleadoTable(),
    UsuarioTable(),
    TecnicoTable(),
    ProveedorTable(),
    ClienteTable(),
    EquipoTable(),
    EquipoFotoTable(),
    EquipoCategoriaTable(),
    EquipoCodigoTable(),
    VentaTable(),
    VentaPagoTable(),
    VentaEquipoTable(),
    VentaInsumoTable(),
    CotizacionTable(),
    CotizacionServicioTable(),
    CotizacionVentaTable(),
    ServicioTable(),
    ServicioTipoTable(),
    ServicioInspeccionTable(),
    ServicioEquipoTable(),
    ServicioHerramientaTable(),
    ServicioInsumoTable(),
    TareaTable(),
    TareaFotoTable(),
  ];

  DataBaseManager() {
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'proyecto.db');
    bool exists = await databaseExists(path);
    if (!exists) {
      _database =
          await openDatabase(path, version: 1, onCreate: (db, version) async {
        print('Inicialización de la base de datos');
        for (var table in tables) {
          await db.execute(table.createTableQuery);
        }
        await UsuarioTable().initTable(db);
      }, onUpgrade: (db, oldVersion, newVersion) async {
        print('Actualización de la base de datos');
        // Iterar sobre las tablas y ejecutar createTableQuery
        for (var table in tables) {
          try {
            await db.execute(table.createTableQuery);
          } catch (e) {
            // Puede haber errores si la tabla ya existe
            print(
                'Error al crear o actualizar la tabla ${table.tableName}: $e');
          }
        }
      });
    } else {
      print('Solamente acceso a la base de datos existente');
      _database = await openDatabase(path);
      // Verificar la existencia de tablas en la base de datos existente
      for (var table in tables) {
        bool tableExists =
            await tableExistsInDatabase(_database, table.tableName);
        if (!tableExists) {
          try {
            await _database.execute(table.createTableQuery);
          } catch (e) {
            print('Error al crear la tabla ${table.tableName}: $e');
          }
        }
      }
    }
  }

  Future<bool> tableExistsInDatabase(Database db, String tableName) async {
    try {
      await db.query(tableName, limit: 1);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> closeDatabase() async {
    if (_database.isOpen) {
      await _database.close();
    }
  }

  // Método para acceder a la base de datos
  Future<Database> get database async {
    await initializeDatabase();
    return _database;
  }

  // Métodos para manejo de información
  Future<void> deleteTable(String tableName) async {
    final table =
        tables.firstWhere((element) => element.tableName == tableName);
    await table.deleteTable(await database);
  }

  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = _database;
    return await db.rawQuery('''SELECT * FROM $tableName''');
  }
}
