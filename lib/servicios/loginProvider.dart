import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
import 'package:movil/modelos/auth.dart';
import 'package:movil/modelos/usuario.dart';
import 'package:bcrypt/bcrypt.dart';

class LoginProvider with ChangeNotifier {
  late final DataBaseManager _dataBaseDB;
  // List<Usuario> _usuarios = [];
  // List<Usuario> get usuarios => _usuarios;

  LoginProvider() {
    _dataBaseDB = DataBaseManager();
    initializeDatabase();
  }
  Future<void> initializeDatabase() async {
    await _dataBaseDB.initializeDatabase();
  }

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  Authentication? _authentication;
  Authentication? get authentication => _authentication;

  Future<List<Map<String, dynamic>>> getUserByUsername(String username) async {
    await initializeDatabase();
    var db = await _dataBaseDB.database;
    return await db
        .query('usuario', where: 'username = ?', whereArgs: [username]);
  }

  Future<int> _checkLocalAuthentication(
      String username, String password) async {
    var localUser = await getUserByUsername(username);
    if (localUser.isNotEmpty) {
      var storedPasswordHash = localUser.first['password'];
      if (BCrypt.checkpw(password, storedPasswordHash) == false) return 1;
      var user = Usuario.fromJson(localUser.first);
      _usuario = user;
      var auth = Authentication(usuario: user, token: 'local_token');
      _authentication = auth;
      return 0;
    }
    return 1;
  }

  Future<int> login(String username, String password) async {
    var local = await _checkLocalAuthentication(username, password);
    if (local == 0) return 0;
    return local;
  }
}
