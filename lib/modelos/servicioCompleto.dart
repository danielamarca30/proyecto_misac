class ServicioCompleto {
  Servicio servicio;
  Cliente cliente;
  Tecnico tecnico;
  List<ServicioEquipo> servicioEquipos;
  List<TareaCompleta> tareas;

  ServicioCompleto({
    required this.servicio,
    required this.cliente,
    required this.tecnico,
    required this.servicioEquipos,
    required this.tareas,
  }) {
    this.servicio.idCliente = this.cliente.id;
    this.servicio.idTecnico = this.tecnico.id;

    for (var item in this.servicioEquipos) {
      item.idServicio = this.servicio.id;
    }

    for (var item in this.tareas) {
      item.tarea.idServicio = this.servicio.id;
    }
  }
}

class Servicio {
  int id;
  int idCliente;
  int idTecnico;
  String nombre;
  String tipo;
  DateTime fecha;
  double total;

  Servicio({
    required this.id,
    required this.idCliente,
    required this.idTecnico,
    required this.nombre,
    required this.tipo,
    required this.fecha,
    required this.total,
  });
}

class Cliente {
  int id;
  String nombre;
  String apellido;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
  });
}

class Tecnico {
  int id;
  String nombre;
  String apellido;

  Tecnico({
    required this.id,
    required this.nombre,
    required this.apellido,
  });
}

class ServicioEquipo {
  int id;
  int idServicio;
  int idEquipo;
  int cantidad;

  ServicioEquipo({
    required this.id,
    required this.idServicio,
    required this.idEquipo,
    required this.cantidad,
  });
}

class Equipo {
  int id;
  String nombre;
  double precio;
  int cantidad;

  Equipo({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });
}

class TareaCompleta {
  Tarea tarea;
  List<TareaFoto> fotos;

  TareaCompleta({
    required this.tarea,
    this.fotos = const [],
  });
}

class Tarea {
  int id;
  int idServicio;
  String tipo;
  String estado;
  String descripcion;

  Tarea({
    required this.id,
    required this.idServicio,
    required this.tipo,
    required this.estado,
    required this.descripcion,
  });
}

class TareaFoto {
  int id;
  int idTarea;
  String urlFoto;

  TareaFoto({
    required this.id,
    required this.idTarea,
    required this.urlFoto,
  });
}
