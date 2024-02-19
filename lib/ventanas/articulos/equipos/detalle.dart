import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movil/modelos/equipo.dart';
import 'package:movil/servicios/equipoProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DetalleEquipo extends StatefulWidget {
  Equipo equipo;
  DetalleEquipo(this.equipo);
  @override
  _DetalleEquipoState createState() => _DetalleEquipoState();
}

class _DetalleEquipoState extends State<DetalleEquipo> {
  // Declaración de variables
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  late Future<EquipoFoto?> equipoFoto;
  late Directory? directory;
  @override
  void initState() {
    super.initState();

    // Inicialización de los controladores
    _nombreController.text = widget.equipo.nombre ?? '';
    _descripcionController.text = widget.equipo.descripcion ?? '';
    _precioController.text = widget.equipo.precio.toString() ?? '';
    _stockController.text = widget.equipo.stock.toString() ?? '';
    getExternalStorageDirectory().then((dir) {
      setState(() {
        directory = dir;
      });
    });
    equipoFoto = EquipoProvider().getEquipoFotoById(widget.equipo.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.equipo.nombre}"),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.edit),
            onPressed: () {
              _mostrarDialogoEditarEquipo();
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
          const Text('DATOS GENERALES:'),
          Card(
            child: InkWell(
              onTap: () {
                // Detalles del cliente
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Nombre: ${widget.equipo.nombre}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Descripcion: ${widget.equipo.descripcion ?? 'N/A'}'),
                        Text('Precio: ${widget.equipo.precio ?? 'N/A'}'),
                        Text('Stock: ${widget.equipo.stock ?? 'N/A'}'),
                        FutureBuilder<EquipoFoto?>(
                          future: equipoFoto,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.archivoUrl != null) {
                              String localImagePath =
                                  '${directory?.path}/${snapshot.data!.id_equipo!}.png';
                              File localImageFile = File(localImagePath);
                              if (localImageFile.existsSync()) {
                                return Image.file(
                                  localImageFile,
                                  width: 500,
                                  height: 500,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return FutureBuilder<void>(
                                  future: downloadAndSaveImage(
                                      snapshot.data!.archivoUrl!,
                                      localImagePath),
                                  builder: (context, snapshotDownload) {
                                    if (snapshotDownload.connectionState ==
                                            ConnectionState.done &&
                                        snapshotDownload.hasData) {
                                      return Image.file(
                                        localImageFile,
                                        width: 500,
                                        height: 500,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                );
                              }
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadAndSaveImage(String imageUrl, String localPath) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final File imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);
    } catch (e) {
      print('Error al descargar y guardar la imagen: $e');
      throw e;
    }
  }

  void _mostrarDialogoEditarEquipo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Equipo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _crearCampoEdicion('Nombre', _nombreController),
                _crearCampoEdicion('Descripcion', _descripcionController),
                _crearCampoEdicion('Precio', _precioController),
                _crearCampoEdicion('Stock', _stockController),
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
        onChanged: (value) {},
      ),
    );
  }

  void _guardarCambios() async {
    setState(() {
      widget.equipo.modificar(
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        stock: int.parse(_stockController.text),
      );
    });
    await EquipoProvider().updateEquipo(widget.equipo);
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
                _eliminarEquipo();
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarEquipo() {
    EquipoProvider().deleteEquipo(widget.equipo.id ?? '');
    Navigator.of(context).pop();
  }
}
