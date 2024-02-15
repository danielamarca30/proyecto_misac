import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Local
import 'package:movil/modelos/equipo.dart';
import 'package:movil/servicios/equipoProvider.dart';

class EquipoCategoriaList extends StatefulWidget {
  final Function(EquipoCategoria) onEquipoCategoriaSelected;
  EquipoCategoriaList({required this.onEquipoCategoriaSelected});
  @override
  _EquipoCategoriaListState createState() => _EquipoCategoriaListState();
}

class _EquipoCategoriaListState extends State<EquipoCategoriaList> {
  late Future<void> _dataLoadingFuture;
  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = _filtrarequipoCategoriaes(null);
  }

  Future<void> _filtrarequipoCategoriaes(String? query) async {
    await EquipoProvider().filtrarEquipoCaterogia(query);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecciona equipoCategoria'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<EquipoProvider>(
              builder: (context, servicioEquipoProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: servicioEquipoProvider.equipoCategorias.length,
                    itemBuilder: (context, index) {
                      EquipoCategoria equipoCategoria =
                          servicioEquipoProvider.equipoCategorias[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(equipoCategoria.nombre ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Descripción: ${equipoCategoria.descripcion ?? 'N/A'}',
                              ),
                            ],
                          ),
                          onTap: () {
                            widget.onEquipoCategoriaSelected(equipoCategoria);
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
          onPressed: () => _mostrarFormularioNuevoequipoCategoria(),
          child: Text('Añadir Nueva Categoria'),
        )
      ],
    );
  }

  void _mostrarFormularioNuevoequipoCategoria() {
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Nueva Categoria'),
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
                  EquipoCategoria nuevoEquipoCategoria = EquipoCategoria(
                    nombre: _nombreController.text.toUpperCase(),
                    descripcion: _descripcionController.text.toUpperCase(),
                  );
                  await EquipoProvider()
                      .createEquipoCategoria(nuevoEquipoCategoria);
                  Navigator.of(context).pop(); // Cierra el formulario
                  widget.onEquipoCategoriaSelected(nuevoEquipoCategoria);
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
