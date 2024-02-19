import 'package:flutter/material.dart';
import 'package:movil/db/db.dart';
import 'package:sqflite/sqflite.dart';

class TreeNode {
  Map<String, dynamic> data;
  TreeNode? parent;

  TreeNode(this.data, {this.parent});

  void addChild(String key, dynamic value) {
    if (data['_'] == null) {
      data['_'] = {};
    }
    data['_']![key] = value;
  }

  void updateData(Map<String, dynamic> newData) {
    data = newData;
  }
}

class VentaDetalle with ChangeNotifier {
  late DataBaseManager _db;
  late TreeNode _venta;

  static final VentaDetalle _instance = VentaDetalle._internal();

  VentaDetalle._internal() {
    _db = DataBaseManager();
    _venta = TreeNode({'_': null});
  }

  factory VentaDetalle() {
    return _instance;
  }

  Future<void> initializedDatabase() async {
    await _db.initializeDatabase();
  }

  Future<void> getVenta(String id) async {
    var db = await _db.database;
    List<Map<String, dynamic>> results =
        await db.query('venta', where: 'id=?', whereArgs: [id]);
    if (results.isNotEmpty) {
      Map<String, dynamic> aux = results[0];
      _venta.updateData(aux);
    }

    List<Map<String, dynamic>> resultsEquipo =
        await db.query('venta_equipo', where: 'id_venta=?', whereArgs: [id]);
    _venta.addChild('venta_equipo', resultsEquipo);

    List<Map<String, dynamic>> resultsPago =
        await db.query('venta_pago', where: 'id_venta=?', whereArgs: [id]);
    if (resultsPago.isNotEmpty) {
      _venta.addChild('venta_pago', resultsPago[0]);
    } else {
      _venta.addChild('venta_pago', null);
    }

    List<Map<String, dynamic>> resultsCotizacionVenta = await db
        .query('cotizacion_venta', where: 'id_venta=?', whereArgs: [id]);
    if (resultsCotizacionVenta.isNotEmpty) {
      TreeNode cotizacionVentaNode = TreeNode({'_': null});
      _venta.addChild('cotizacion_venta', cotizacionVentaNode);

      cotizacionVentaNode.updateData(resultsCotizacionVenta[0]);

      List<Map<String, dynamic>> resultsCotizacion = await db.query(
          'cotizacion',
          where: 'id=?',
          whereArgs: [cotizacionVentaNode.data['_']['id']]);
      cotizacionVentaNode.addChild('cotizacion', resultsCotizacion[0]);
    } else {
      _venta.addChild('cotizacion_venta', null);
    }
    notifyListeners();
  }

  Future<void> updateVenta() async {
    final db = await _db.database;

    await _updateTreeNode(db, _venta);

    notifyListeners();
  }

  Future<void> deleteVenta(String id) async {
    final db = await _db.database;
    await db.delete('venta', where: 'id=?', whereArgs: [id]);

    _venta = TreeNode({'_': null});

    notifyListeners();
  }

  Future<void> insertVenta() async {
    final db = await _db.database;

    await _insertTreeNode(db, _venta);

    notifyListeners();
  }

  Future<void> _updateTreeNode(Database db, TreeNode node) async {
    Map<String, dynamic> auxNodeData = Map.from(node.data);
    auxNodeData['_'] = null;

    await db.update('venta', auxNodeData,
        where: 'id=?', whereArgs: [auxNodeData['id']]);

    List<TreeNode> childNodes = _getChildrenNodes(node);
    for (var childNode in childNodes) {
      await _updateTreeNode(db, childNode);
    }
  }

  Future<void> _insertTreeNode(Database db, TreeNode node) async {
    await db.insert('venta', node.data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    List<TreeNode> childNodes = _getChildrenNodes(node);
    for (var childNode in childNodes) {
      await _insertTreeNode(db, childNode);
    }
  }

  List<TreeNode> _getChildrenNodes(TreeNode node) {
    List<TreeNode> children = [];
    if (node.data['_'] != null) {
      node.data['_']!.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            children.add(TreeNode({key: item}, parent: node));
          }
        } else {
          children.add(TreeNode({key: value}, parent: node));
        }
      });
    }
    return children;
  }
}




// import 'package:flutter/material.dart';
// import 'package:movil/db/db.dart';
// //Local

// import 'package:movil/modelos/venta.dart';

// class VentaDetalle with ChangeNotifier {
//   Map<String, dynamic> _venta = {'_': null};
//   Map<String, dynamic> get venta => _venta;
//   late DataBaseManager _db;
//   static final VentaDetalle _instance = VentaDetalle._internal();

//   VentaDetalle._internal() {
//     _db = DataBaseManager();
//   }

//   factory VentaDetalle() {
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
