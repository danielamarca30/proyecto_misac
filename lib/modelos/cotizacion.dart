class Cotizacion {
  String? id;
  String? id_cliente;
  String? id_empleado;
  double? monto;
  String? estado;
  Cotizacion({
    this.id,
    this.id_cliente,
    this.id_empleado,
    this.monto,
    this.estado,
  });
  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
        id: json['id'] ?? '',
        id_cliente: json['id_cliente'] ?? '',
        id_empleado: json['id_empleado'] ?? '',
        monto: json['monto'] ?? null,
        estado: json['estado'] ?? '');
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_empleado': id_empleado,
      'id_cliente': id_cliente,
      'monto': monto,
      'estado': estado,
    };
  }

  void modificar({
    String? id,
    String? id_cliente,
    String? id_empleado,
    DateTime? fechaVaidez,
    DateTime? fechaCreacion,
    double? monto,
    String? estado,
  }) {
    this.id = id ?? this.id;
    this.id_empleado = id_empleado ?? this.id_empleado;
    this.id_cliente = id_cliente ?? this.id_cliente;
    this.monto = monto ?? this.monto;
    this.estado = estado ?? this.estado;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class CotizacionVenta {
  String? id;
  String? id_cotizacion;
  String? id_venta;
  DateTime? fechaCreacion;
  DateTime? fechaValidez;
  double? monto;
  String? estado;
  CotizacionVenta({
    this.id,
    this.id_cotizacion,
    this.id_venta,
    this.fechaCreacion,
    this.fechaValidez,
    this.monto,
    this.estado,
  });
  factory CotizacionVenta.fromJson(Map<String, dynamic> json) {
    return CotizacionVenta(
        id: json['id'] ?? '',
        id_cotizacion: json['id_cotizacion'] ?? '',
        id_venta: json['id_venta'] ?? '',
        fechaCreacion: _parseDateTime(json['fechaCreacion']) ?? null,
        fechaValidez: _parseDateTime(json['fechaValidez']) ?? null,
        monto: json['monto'] ?? null,
        estado: json['estado'] ?? '');
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_venta': id_venta,
      'id_cotizacion': id_cotizacion,
      'fechaCreacion': fechaCreacion,
      'fechaValidez': fechaValidez,
      'monto': monto,
      'estado': estado,
    };
  }

  void modificar({
    String? id,
    String? id_cotizacion,
    String? id_venta,
    DateTime? fechaValidez,
    DateTime? fechaCreacion,
    double? monto,
    String? estado,
  }) {
    this.id = id ?? this.id;
    this.id_venta = id_venta ?? this.id_venta;
    this.id_cotizacion = id_cotizacion ?? this.id_cotizacion;
    this.fechaCreacion = fechaCreacion ?? this.fechaCreacion;
    this.fechaValidez = fechaValidez ?? this.fechaValidez;
    this.monto = monto ?? this.monto;
    this.estado = estado ?? this.estado;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class CotizacionServicio {
  String? id;
  String? id_cotizacion;
  String? id_servicio;
  DateTime? fechaCreacion;
  DateTime? fechaValidez;
  double? monto;
  String? estado;
  CotizacionServicio({
    this.id,
    this.id_cotizacion,
    this.id_servicio,
    this.fechaCreacion,
    this.fechaValidez,
    this.monto,
    this.estado,
  });
  factory CotizacionServicio.fromJson(Map<String, dynamic> json) {
    return CotizacionServicio(
        id: json['id'] ?? '',
        id_cotizacion: json['id_cotizacion'] ?? '',
        id_servicio: json['id_servicio'] ?? '',
        fechaCreacion: _parseDateTime(json['fechaCreacion']) ?? null,
        fechaValidez: _parseDateTime(json['fechaValidez']) ?? null,
        monto: json['monto'] ?? null,
        estado: json['estado'] ?? '');
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_servicio': id_servicio,
      'id_cotizacion': id_cotizacion,
      'fechaCreacion': fechaCreacion,
      'fechaValidez': fechaValidez,
      'monto': monto,
      'estado': estado,
    };
  }

  void modificar({
    String? id,
    String? id_cotizacion,
    String? id_servicio,
    DateTime? fechaVaidez,
    DateTime? fechaCreacion,
    double? monto,
    String? estado,
  }) {
    this.id = id ?? this.id;
    this.id_servicio = id_servicio ?? this.id_servicio;
    this.id_cotizacion = id_cotizacion ?? this.id_cotizacion;
    this.fechaCreacion = fechaCreacion ?? this.fechaCreacion;
    this.fechaValidez = fechaValidez ?? this.fechaValidez;
    this.monto = monto ?? this.monto;
    this.estado = estado ?? this.estado;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}
