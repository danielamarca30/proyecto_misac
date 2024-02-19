import 'package:movil/modelos/cotizacion.dart';

class VentaDetalle {
  Venta? venta;
  VentaPago? ventaPago;
  List<VentaEquipo>? ventaEquipos;
  Cotizacion? cotizacion;
  CotizacionVenta? cotizacionVenta;

  VentaDetalle(
      {this.venta,
      this.ventaPago,
      this.ventaEquipos,
      this.cotizacion,
      this.cotizacionVenta});
}

class Venta {
  String? id;
  String? id_cliente;
  String? id_empleado;
  String? tipo;
  String? estado;
  DateTime? fecha;
  double? total;
  Venta(
      {this.id,
      this.id_cliente,
      this.id_empleado,
      this.tipo,
      this.estado,
      this.fecha,
      this.total});
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
        id: json['id'] ?? '',
        id_cliente: json['id_cliente'] ?? '',
        id_empleado: json['id_empleado'] ?? '',
        tipo: json['tipo'] ?? '',
        estado: json['estado'] ?? '',
        fecha: _parseDateTime(json['fecha']) ?? null,
        total: json['total'] ?? null);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_empleado': id_empleado,
      'id_cliente': id_cliente,
      'tipo': tipo,
      'estado': estado,
      'fecha': fecha,
      'total': total
    };
  }

  void modificar(
      {String? id,
      String? id_cliente,
      String? id_empleado,
      String? tipo,
      String? estado,
      DateTime? fecha,
      double? total}) {
    this.id = id ?? this.id;
    this.id_empleado = id_empleado ?? this.id_empleado;
    this.id_cliente = id_cliente ?? this.id_cliente;
    this.tipo = tipo ?? this.tipo;
    this.estado = estado ?? this.estado;
    this.fecha = fecha ?? this.fecha;
    this.total = total ?? this.total;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class VentaPago {
  String? id;
  String? id_venta;
  DateTime? fecha;
  double? monto;
  VentaPago({
    this.id,
    this.id_venta,
    this.fecha,
    this.monto,
  });
  factory VentaPago.fromJson(Map<String, dynamic> json) {
    return VentaPago(
      id: json['id'] ?? '',
      id_venta: json['id_venta'] ?? '',
      fecha: _parseDateTime(json['fecha']) ?? null,
      monto: json['monto'] ?? null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_venta': id_venta,
      'fecha': fecha,
      'monto': monto,
    };
  }

  void modificar({
    String? id,
    String? id_venta,
    DateTime? fecha,
    double? monto,
  }) {
    this.id = id ?? this.id;
    this.id_venta = id_venta ?? this.id_venta;
    this.fecha = fecha ?? this.fecha;
    this.monto = monto ?? this.monto;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class VentaEquipo {
  String? id;
  String? id_venta;
  String? id_equipo;
  int? cantidad;
  String? unidad;
  VentaEquipo(
      {this.id, this.id_venta, this.id_equipo, this.cantidad, this.unidad});
  factory VentaEquipo.fromJson(Map<String, dynamic> json) {
    return VentaEquipo(
        id: json["id"] ?? '',
        id_equipo: json['id_equipo'] ?? '',
        id_venta: json['id_venta'] ?? '',
        cantidad: int.parse(json['cantidad'] ?? '0'),
        unidad: json['unidad']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_equipo': id_equipo,
      'id_venta': id_venta,
      'cantidad': cantidad,
      'unidad': unidad
    };
  }

  void modificar(
    String? id,
    String? id_venta,
    String? id_equipo,
    int? cantidad,
    String? unidad,
  ) {
    this.id = id ?? this.id;
    this.id_equipo = id_equipo ?? this.id_equipo;
    this.id_venta = id_venta ?? this.id_venta;
    this.cantidad = cantidad ?? this.cantidad;
    this.unidad = unidad ?? this.unidad;
  }
}
