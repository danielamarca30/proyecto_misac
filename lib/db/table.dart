import 'package:sqflite/sqflite.dart';

abstract class DatabaseTable {
  String get tableName;
  String get createTableQuery;
  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS $tableName');
      await txn.execute(createTableQuery);
    });
  }
}
