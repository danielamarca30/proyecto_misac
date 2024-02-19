import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//Local
import 'package:movil/modelos/empleado.dart';
import 'package:movil/servicios/empleadoProvider.dart';

class DetalleEmpleado extends StatefulWidget {
  Empleado empleado;
  DetalleEmpleado(this.empleado);
  @override
  _DetalleEmpleadoState createState() => _DetalleEmpleadoState();
}

class _DetalleEmpleadoState extends State<DetalleEmpleado> {
  // Declaración de variables
  final _nombresController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  late Tecnico tecnico;

  @override
  void initState() {
    super.initState();
    _nombresController.text = widget.empleado.nombres ?? '';
    _apellidoPaternoController.text = widget.empleado.apellidoPaterno ?? '';
    _apellidoMaternoController.text = widget.empleado.apellidoMaterno ?? '';
    _ciController.text = widget.empleado.ci ?? '';
    _direccionController.text = widget.empleado.direccion ?? '';
    _telefonoController.text = widget.empleado.telefono ?? '';
    _correoController.text = widget.empleado.correo ?? '';

    // Utilizar then para manejar la asincronía
    EmpleadoProvider()
        .getTecnicoById(widget.empleado.id ?? '')
        .then((tecnicoObtenido) {
      setState(() {
        tecnico = tecnicoObtenido;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.empleado.nombreCompleto}"),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.edit),
            onPressed: () {
              _mostrarDialogoEditarempleado();
            },
          ),
          IconButton(
            color: Colors.red,
            icon: Icon(Icons.delete),
            onPressed: () {
              _mostrarDialogoEliminarempleado();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: EmpleadoProvider().getTecnicoById(widget.empleado.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                const Text('DATOS PERSONALES:'),
                Card(
                  child: InkWell(
                    onTap: () {
                      // Detalles del empleado
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Nombre: ${widget.empleado.nombres} ${widget.empleado.apellidoPaterno} ${widget.empleado.apellidoMaterno}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Dirección: ${widget.empleado.direccion ?? 'N/A'}'),
                              Text(
                                  'Telefono: ${widget.empleado.telefono ?? 'N/A'}'),
                              Text('Rol: ${widget.empleado.rol ?? 'N/A'}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Text('Servicios'),
                SizedBox(height: 10),
                const Text('Equipos')
              ],
            );
          } else {
            tecnico = snapshot.data as Tecnico;
            return Column(
              children: [
                const Text('DATOS PERSONALES:'),
                Card(
                  child: InkWell(
                    onTap: () {
                      // Detalles del empleado
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Nombre: ${widget.empleado.nombres} ${widget.empleado.apellidoPaterno} ${widget.empleado.apellidoMaterno}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Dirección: ${widget.empleado.direccion ?? 'N/A'}'),
                              Text(
                                  'Telefono: ${widget.empleado.telefono ?? 'N/A'}'),
                              Text('Rol: ${widget.empleado.rol ?? 'N/A'}'),
                              if (tecnico != null)
                                Text(
                                    'Especialidad: ${tecnico.especialidad ?? 'N/A'}'),
                              if (tecnico == null)
                                Text(
                                    'Cargando especialidad...'), // Muestra un indicador de carga
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Text('Servicios'),
                SizedBox(height: 10),
                const Text('Equipos')
              ],
            );
          }
        },
      ),
    );
  }

  void _mostrarDialogoEditarempleado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar empleado'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _crearCampoEdicion('Nombres', _nombresController),
                _crearCampoEdicion(
                    'Apellido Paterno', _apellidoPaternoController),
                _crearCampoEdicion(
                    'Apellido Materno', _apellidoMaternoController),
                _crearCampoEdicion('Ci', _ciController),
                _crearCampoEdicion('Dirección', _direccionController),
                _crearCampoEdicion('Teléfono', _telefonoController),
                _crearCampoEdicion('Correo', _correoController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _guardarCambios();
                Navigator.of(context).pop();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        );
      },
    );
  }

  Widget _crearCampoEdicion(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
      ),
    );
  }

  void _guardarCambios() {
    setState(() {
      widget.empleado.modificar(
        nombres: _nombresController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        nombreCompleto:
            "${_nombresController.text ?? ''} ${_apellidoPaternoController.text ?? ''} ${_apellidoMaternoController.text ?? ''}",
        ci: _ciController.text,
        correo: _correoController.text,
        direccion: _direccionController.text,
        telefono: _telefonoController.text,
      );
    });
    EmpleadoProvider().updateEmpleado(widget.empleado);
  }

  void _mostrarDialogoEliminarempleado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar empleado'),
          content: Text('¿Desea eliminar este empleado?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarempleado();
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarempleado() {
    EmpleadoProvider().deleteEmpleado(widget.empleado.id ?? '');
    Navigator.of(context).pop();
  }
}
