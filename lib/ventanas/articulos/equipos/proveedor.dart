import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Local
import 'package:movil/modelos/equipo.dart';
import 'package:movil/servicios/proveedorProvider.dart';

class ProveedorList extends StatefulWidget {
  final Function(Proveedor) onProveedorSelected;
  ProveedorList({required this.onProveedorSelected});
  @override
  _ProveedorListState createState() => _ProveedorListState();
}

class _ProveedorListState extends State<ProveedorList> {
  late Future<void> _dataLoadingFuture;
  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = _filtrarProveedores(null);
  }

  Future<void> _filtrarProveedores(String? query) async {
    await ProveedorProvider().filtrarProveedor(query);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecciona Proveedor'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ProveedorProvider>(
              builder: (context, servicioProveedorProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: servicioProveedorProvider.proveedores.length,
                    itemBuilder: (context, index) {
                      Proveedor proveedor =
                          servicioProveedorProvider.proveedores[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(proveedor.nombre ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dirección: ${proveedor.direccion ?? 'N/A'}',
                              ),
                              Text(
                                'Contacto: ${proveedor.contacto ?? 'N/A'}',
                              ),
                            ],
                          ),
                          onTap: () {
                            widget.onProveedorSelected(proveedor);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => _mostrarFormularioNuevoProveedor(),
          child: Text('Añadir Nuevo Cliente'),
        )
      ],
    );
  }

  void _mostrarFormularioNuevoProveedor() {
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _direccionController = TextEditingController();
    final _contactoController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Nuevo Proveedor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(hintText: "Nombre"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _direccionController,
                  decoration: InputDecoration(hintText: "Dirección"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _contactoController,
                  decoration: InputDecoration(hintText: "Contacto"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(hintText: "Descripción"),
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Agregar'),
              onPressed: () async {
                try {
                  Proveedor nuevoProveedor = Proveedor(
                      nombre: _nombreController.text.toUpperCase(),
                      descripcion: _descripcionController.text.toUpperCase(),
                      direccion: _direccionController.text.toUpperCase(),
                      contacto: _contactoController.text.toUpperCase());
                  await ProveedorProvider().createProveedor(nuevoProveedor);
                  Navigator.of(context).pop(); // Cierra el formulario
                  widget.onProveedorSelected(nuevoProveedor);
                  FocusScope.of(context).unfocus(); // Esto ocultará el teclado
                  Navigator.of(context).pop();
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.red,
                        title: Text('Error'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(e.toString()),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
