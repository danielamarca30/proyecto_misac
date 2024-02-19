import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
import 'package:sqflite/sqflite.dart';

// class TreeStruct {
//   String nombre;
//   dynamic data;
//   List<TreeStruct> children;
//   TreeStruct({
//     required this.nombre,
//     required this.data,
//     this.children = const [],
//   });
//   factory TreeStruct.fromMap(Map<String, dynamic> map) {
//     String nombre = map.keys.first;
//     dynamic data = map[nombre];
//     List<TreeStruct> children = [];
//     if (data is Map<String, dynamic> && data.containsKey('_')) {
//       dynamic childData = data['_'];

//       if (childData is List) {
//         for (var item in childData) {
//           if (item is Map<String, dynamic>) {
//             children.add(TreeStruct.fromMap(item));
//           }
//         }
//       }
//       data.remove('_');
//     }

//     return TreeStruct(nombre: nombre, data: data, children: children);
//   }
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> result = {nombre: data};

//     if (children.isNotEmpty) {
//       List<Map<String, dynamic>> childList = [];

//       for (TreeStruct child in children) {
//         childList.add(child.toMap());
//       }

//       result['_'] = childList;
//     }

//     return result;
//   }

//   void updateStructure(Map<String, dynamic> newMap) {
//     String newNombre = newMap.keys.first;
//     dynamic newData = newMap[newNombre];

//     if (newData is Map<String, dynamic> && newData.containsKey('_')) {
//       dynamic newChildData = newData['_'];

//       if (newChildData is List) {
//         children = [];
//         for (var item in newChildData) {
//           if (item is Map<String, dynamic>) {
//             children.add(TreeStruct.fromMap(item));
//           }
//         }
//       }
//       newData.remove('_');
//     }

//     nombre = newNombre;
//     data = newData;
//   }

//   void printTree(TreeStruct node, [int level = 0]) {
//     String indentation = '  ' * level;
//     print('$indentation${node.nombre}: ${node.data}');

//     for (TreeStruct child in node.children) {
//       printTree(child, level + 1);
//     }
//   }
// }

class VentaDetalleProvider with ChangeNotifier {
  late DataBaseManager _db;
  Map<String, dynamic> _ventaState = {};
  Map<String, dynamic> _cotizacionState = {};
  Map<String, dynamic> _cotizacionVentaState = {};
  List<Map<String, dynamic>> _equiposState = [];

  static final VentaDetalleProvider _instance =
      VentaDetalleProvider._internal();

  VentaDetalleProvider._internal() {
    _db = DataBaseManager();
  }

  factory VentaDetalleProvider() {
    return _instance;
  }

  Future<void> initializedDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> createVenta({
    Map<String, dynamic>? nuevaVenta,
    List<Map<String, dynamic>>? nuevosEquipos,
    Map<String, dynamic>? nuevaCotizacion,
    Map<String, dynamic>? nuevaCotizacionVenta,
  }) async {
    print('crearr');
    var db = await _db.database;
    if (nuevaVenta != null && nuevaVenta.isNotEmpty) {
      _ventaState = {...nuevaVenta};
      await db.insert('venta', nuevaVenta,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    if (nuevosEquipos != null && nuevosEquipos.isNotEmpty) {
      _equiposState = [...nuevosEquipos];
      for (var equipo in nuevosEquipos) {
        await db.insert('venta_equipo', equipo,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    if (nuevaCotizacion != null && nuevaCotizacion.isNotEmpty) {
      _cotizacionState = {...nuevaCotizacion};
      await db.insert('cotizacion', nuevaCotizacion,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    if (nuevaCotizacionVenta != null && nuevaCotizacionVenta.isNotEmpty) {
      _cotizacionVentaState = {...nuevaCotizacionVenta};
      await db.insert('cotizacion_venta', nuevaCotizacionVenta,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Future<void> getVenta(String id) async {
  //   dynamic aux;
  //   dynamic data = {};
  //   var db = await _db.database;
  //   List<Map<String, dynamic>> results =
  //       await db.query('venta', where: 'id=?', whereArgs: [id]);
  //   if (results.isNotEmpty) {
  //     Map<String, dynamic> aux = results[0];
  //     data['venta'] = aux;
  //   }

  //   List<Map<String, dynamic>> resultsEquipo =
  //       await db.query('venta_equipo', where: 'id_venta=?', whereArgs: [id]);
  //   data['_'] = [
  //     {'venta_equipo': resultsEquipo}
  //   ];
  //   List<Map<String, dynamic>> resultsPago =
  //       await db.query('venta_pago', where: 'id_venta=?', whereArgs: [id]);
  //   aux = data['_'];
  //   data['_'].add({'venta_pago': resultsPago[0]});
  //   List<Map<String, dynamic>> resultsCotizacionVenta = await db
  //       .query('cotizacion_venta', where: 'id_venta=?', whereArgs: [id]);
  //   if (resultsCotizacionVenta.isEmpty) {
  //     aux = data['_'];
  //     data['_'].add({'cotizacion_venta': resultsCotizacionVenta});
  //     List<Map<String, dynamic>> resultsCotizacion = await db.query(
  //         'cotizacion',
  //         where: 'id_cotizacion_venta=?',
  //         whereArgs: [resultsCotizacionVenta[0]['id']]);
  //     aux = data['_'];
  //     data['_'].add({'cotizacion': resultsCotizacion[0]});
  //   }
  //   notifyListeners();
  // }
}




// import 'package:flutter/material.dart';
// import 'package:movil/db/db.dart';
// //Local

// import 'package:movil/modelos/venta.dart';

// class VentaDetalleProvider with ChangeNotifier {
//   Map<String, dynamic> _venta = {'_': null};
//   Map<String, dynamic> get venta => _venta;
//   late DataBaseManager _db;
//   static final VentaDetalleProvider _instance = VentaDetalleProvider._internal();

//   VentaDetalleProvider._internal() {
//     _db = DataBaseManager();
//   }

//   factory VentaDetalleProvider() {
//     return _instance;
//   }

//   Future<void> initializedDatabase() async {
//     await _db.initializeDatabase();
//   }

//   Future<void> getVenta(String id) async {
//     var db = await _db.database;
//     List<Map<String, dynamic>> results =
//         await db.query('venta', where: 'id=?', whereArgs: [id]);
//     if (results.isNotEmpty) {
//       Map<String, dynamic> aux = results[0];
//       aux['_'] = _venta['_'];
//       _venta = aux;
//     }

//     List<Map<String, dynamic>> resultsEquipo =
//         await db.query('venta_equipo', where: 'id_venta=?', whereArgs: [id]);
//     _venta['equipo'] = resultsEquipo;

//     List<Map<String, dynamic>> resultsPago =
//         await db.query('venta_pago', where: 'id_venta=?', whereArgs: [id]);
//     if (resultsPago.isNotEmpty) {
//       _venta['_']['venta_pago'] = resultsPago[0];
//     } else {
//       _venta['_']['venta_pago'] = null;
//     }

//     List<Map<String, dynamic>> resultsCotizacionVenta = await db
//         .query('cotizacion_venta', where: 'id_venta=?', whereArgs: [id]);
//     if (resultsCotizacionVenta.isNotEmpty) {
//       _venta['_']['cotizacion_venta'] = resultsCotizacionVenta[0];
//       List<Map<String, dynamic>> resultsCotizacion = await db.query(
//           'cotizacion',
//           where: 'id=?',
//           whereArgs: [_venta['_']['cotizacion_venta']['id']]);
//       _venta['_']['cotizacion_venta']['_'] = null;
//       _venta['_']['cotizacion_venta']['_']['cotizacion'] = resultsCotizacion[0];
//     } else {
//       _venta['_']['cotizacion_venta'] = null;
//     }

//     notifyListeners();
//   }

//   Future<void> updateVenta() async {
//     final db = await _db.database;

//     Map<String, dynamic> auxVenta =
//         Map.from(_venta); // Utilizar Map.from para realizar una copia del mapa
//     auxVenta['_'] = null;

//     await db
//         .update('venta', auxVenta, where: 'id=?', whereArgs: [auxVenta['id']]);

//     if (_venta['_']['equipo'] != null) {
//       _venta['_']['equipo'].forEach((elemento) async {
//         Map<String, dynamic> auxEquipo = Map.from(elemento);
//         auxEquipo['_'] = null;
//         await db.update('venta_equipo', auxEquipo,
//             where: 'id=?', whereArgs: [auxEquipo['id']]);
//       });
//     }

//     if (_venta['_']['venta_pago'] != null) {
//       Map<String, dynamic> auxPago = Map.from(_venta['_']['venta_pago']);
//       auxPago['_'] = null;
//       await db.update('venta_pago', auxPago,
//           where: 'id=?', whereArgs: [auxPago['id']]);
//     }

//     if (_venta['_']['cotizacion_venta'] != null) {
//       Map<String, dynamic> auxCotizacion =
//           Map.from(_venta['_']['cotizacion_venta']);
//       auxCotizacion['_'] = null;
//       await db.update('cotizacion_venta', auxCotizacion,
//           where: 'id=?', whereArgs: [auxCotizacion['id']]);
//     }

//     notifyListeners();
//   }

//   Future<void> deleteVenta(String id) async {
//     final db = await _db.database;
//     await db.delete('venta', where: 'id=?', whereArgs: [id]);
//     Map<String, dynamic> aux = {};
//     aux['_'] = _venta['_'];
//     _venta = aux;
//     await db.delete('venta_equipo',
//         where: 'id=?', whereArgs: [_venta['_']['equipo']['id']]);

//     await db.delete('venta_pago',
//         where: 'id=?', whereArgs: [_venta['_']['venta_pago']['id']]);

//     await db.delete('cotizacion',
//         where: 'id=?',
//         whereArgs: [_venta['_']['cotizacion_venta']['_']['cotizacion']['id']]);

//     await db.delete('cotizacion_venta',
//         where: 'id=?', whereArgs: [_venta['_']['cotizacion_venta']['id']]);

//     notifyListeners();
//   }
// }
