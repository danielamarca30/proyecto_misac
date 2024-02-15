import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/modelos/cliente.dart';
import 'package:movil/servicios/clienteProvider.dart';

class DetalleCliente extends StatefulWidget {
  Cliente cliente;
  DetalleCliente(this.cliente);
  @override
  _DetalleClienteState createState() => _DetalleClienteState();
}

class _DetalleClienteState extends State<DetalleCliente> {
  // Declaración de variables
  final _nombresController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _selectedLatLng;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Inicialización de los controladores
    _nombresController.text = widget.cliente.nombres ?? '';
    _apellidoPaternoController.text = widget.cliente.apellidoPaterno ?? '';
    _apellidoMaternoController.text = widget.cliente.apellidoMaterno ?? '';
    _ciController.text = widget.cliente.ci ?? '';
    _direccionController.text = widget.cliente.direccion ?? '';
    _telefonoController.text = widget.cliente.telefono ?? '';
    _correoController.text = widget.cliente.correo ?? '';
    _latitudController.text = widget.cliente.ubicacionLat ?? '';
    _longitudController.text = widget.cliente.ubicacionLng ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.cliente.nombreCompleto}"),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.edit),
            onPressed: () {
              _mostrarDialogoEditarCliente();
            },
          ),
          IconButton(
            color: Colors.red,
            icon: Icon(Icons.delete),
            onPressed: () {
              _mostrarDialogoEliminarCliente();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('DATOS PERSONALES:'),
          Card(
            child: InkWell(
              onTap: () {
                // Detalles del cliente
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Nombre: ${widget.cliente.nombres} ${widget.cliente.apellidoPaterno} ${widget.cliente.apellidoMaterno}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dirección: ${widget.cliente.direccion ?? 'N/A'}'),
                        Text('Telefono: ${widget.cliente.telefono ?? 'N/A'}'),
                        _mostrarMapa(
                          widget.cliente.ubicacionLat.toString(),
                          widget.cliente.ubicacionLng.toString(),
                        ),
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
      ),
    );
  }

  Widget _mostrarMapa(String? latitud, String? longitud) {
    if (latitud != null ||
        latitud != '' ||
        longitud != null ||
        longitud != '') {
      _selectedLatLng =
          LatLng(double.parse(latitud ?? '0'), double.parse(longitud ?? '0'));
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('selectedLocation'),
        position: _selectedLatLng!,
      ));
      return Container(
        height: 400,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _selectedLatLng!,
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: _markers,
          onLongPress: (LatLng longPressLatLng) {
            setState(() {
              _markers.clear();
              _markers.add(Marker(
                markerId: MarkerId('selectedLocation'),
                position: longPressLatLng,
              ));
              _selectedLatLng = longPressLatLng;
              _latitudController.text = _selectedLatLng!.latitude.toString();
              _longitudController.text = _selectedLatLng!.longitude.toString();
            });
          },
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void _mostrarDialogoEditarCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Cliente'),
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
                _crearCampoEdicion('Latitud', _latitudController),
                _crearCampoEdicion('Longitud', _longitudController),
                _mostrarMapa(_latitudController.text, _longitudController.text),
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
      widget.cliente.modificar(
          nombres: _nombresController.text,
          apellidoPaterno: _apellidoPaternoController.text,
          apellidoMaterno: _apellidoMaternoController.text,
          nombreCompleto:
              "${_nombresController.text ?? ''} ${_apellidoPaternoController.text ?? ''} ${_apellidoMaternoController.text ?? ''}",
          ci: _ciController.text,
          correo: _correoController.text,
          direccion: _direccionController.text,
          telefono: _telefonoController.text,
          ubicacionLat: _latitudController.text,
          ubicacionLng: _longitudController.text);
    });
    ClienteProvider().updateCliente(widget.cliente);
  }

  void _mostrarDialogoEliminarCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cliente'),
          content: Text('¿Desea eliminar este cliente?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarCliente();
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarCliente() {
    ClienteProvider().deleteCliente(widget.cliente.id ?? '');
    Navigator.of(context).pop();
  }
}
