import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/ventanas/clientes/detalle.dart';
import 'package:provider/provider.dart';
import 'package:nanoid/nanoid.dart';

import 'package:movil/servicios/clienteProvider.dart';
import 'package:movil/elementos/bottomNavigator.dart';
import 'package:movil/elementos/Input.dart';
import 'package:movil/modelos/cliente.dart';

class ClienteWindow extends StatefulWidget {
  @override
  _ClienteWindowState createState() => _ClienteWindowState();
}

class _ClienteWindowState extends State<ClienteWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            onChanged: _filtrarClientes,
            decoration: InputDecoration(
              labelText: 'Buscar Cliente',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(child: Consumer<ClienteProvider>(
          builder: (context, servicioClienteProvider, child) {
            print(
                'servicioCliente: ${servicioClienteProvider.clientes.length}');
            return ListView.builder(
              itemCount: servicioClienteProvider.clientes.length,
              itemBuilder: (context, index) {
                Cliente cliente = servicioClienteProvider.clientes[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetalleCliente(cliente)));
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(cliente.nombres ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cliente.apellidoPaterno} ${cliente.apellidoMaterno}',
                              ),
                              Text('Dirección: ${cliente.direccion ?? 'N/A'}'),
                              Text('Telefono: ${cliente.telefono ?? 'N/A'}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ))
      ]),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoCliente()),
          );
        },
      ),
    );
  }

  void _filtrarClientes(String query) async {
    if (query.isEmpty) {
      await ClienteProvider().filtrarCliente(null);
    } else {
      await ClienteProvider().filtrarCliente(query.toLowerCase());
    }
  }
}

class NuevoCliente extends StatefulWidget {
  @override
  _NuevoClienteState createState() => _NuevoClienteState();
}

class _NuevoClienteState extends State<NuevoCliente> {
  final _nombresController = TextEditingController();
  final _cod_clienteController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  LatLng _selectedLatLng = LatLng(-17.9833300, -67.1500000);
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(
              controller: _cod_clienteController, label: 'Codigo Cliente'),
          CustomTextField(controller: _nombresController, label: 'Nombres'),
          CustomTextField(
              controller: _apellidoPaternoController,
              label: 'Apellido Paterno'),
          CustomTextField(
              controller: _apellidoMaternoController,
              label: 'Apellido Materno'),
          CustomTextField(controller: _ciController, label: 'Carnet Identidad'),
          CustomTextField(
            controller: _direccionController,
            label: 'Dirección',
            maxLines: 2,
          ),
          CustomTextField(controller: _telefonoController, label: 'Telefono'),
          CustomTextField(controller: _correoController, label: 'Correo'),
          Container(
            width: 400,
            height: 400,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLatLng,
                    zoom: 15.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onLongPress: _onMapLongPress,
                  markers: _markers,
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _selectedLatLng,
                          zoom: 15,
                        ),
                      ));
                    },
                    child: Icon(Icons.location_searching),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nombresController.text == null ||
                  _nombresController.text == "" ||
                  _ciController.text == null ||
                  _ciController.text == "" ||
                  _direccionController.text == null ||
                  _direccionController.text == "" ||
                  _correoController.text == null ||
                  _correoController.text == "") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error:'),
                      content: Text(
                          "Error al crear Cliente, debe llenar los campos: nombres, carnet de identidad, telefono, descripcion, correo de manera obligatoria"),
                      actions: [
                        TextButton(
                          child: Text("Volver"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              } else {
                Cliente cliente = Cliente(
                  id: nanoid(10),
                  cod_cliente: _cod_clienteController.text ?? '',
                  nombres: _nombresController.text ?? '',
                  apellidoPaterno: _apellidoPaternoController.text ?? '',
                  apellidoMaterno: _apellidoMaternoController.text ?? '',
                  nombreCompleto:
                      "${_nombresController.text ?? ''} ${_apellidoPaternoController.text ?? ''} ${_apellidoMaternoController.text ?? ''}",
                  direccion: _direccionController.text,
                  telefono: _telefonoController.text,
                  ci: _ciController.text,
                  correo: _correoController.text,
                  ubicacionLat: _selectedLatLng?.latitude.toString() ?? '0.0',
                  ubicacionLng: _selectedLatLng?.longitude.toString() ?? '0.0',
                );
                _createCliente(context, cliente);
              }
            },
            child: Text('Registrar Cliente'),
          )
        ],
      ),
    );
  }

  void _createCliente(BuildContext context, Cliente cliente) async {
    await ClienteProvider().createCliente(cliente);
    Navigator.of(context).pop();
  }

  void _onMapLongPress(LatLng longPressLatLng) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('selectedLocation'),
        position: longPressLatLng,
      ));
      _selectedLatLng = longPressLatLng;
    });
  }
}
