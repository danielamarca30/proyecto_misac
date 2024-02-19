import 'package:flutter/material.dart';
import 'package:movil/ventanas/servicios/tarea.dart';
import 'package:provider/provider.dart';
import 'package:nanoid/nanoid.dart';
//Local
import 'package:movil/elementos/bottomNavigator.dart';
import 'package:movil/servicios/empleadoProvider.dart';
import 'package:movil/servicios/clienteProvider.dart';
import 'package:movil/servicios/servicioProvider.dart';
import 'package:movil/servicios/equipoProvider.dart';
import 'package:movil/modelos/empleado.dart';
import 'package:movil/modelos/cliente.dart';
import 'package:movil/modelos/servicio.dart';
import 'package:movil/modelos/equipo.dart';

class ServicioWindow extends StatefulWidget {
  @override
  _ServicioWindowState createState() => _ServicioWindowState();
}

class _ServicioWindowState extends State<ServicioWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Servicios'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.receipt))]),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String querySearch) {},
              decoration: InputDecoration(
                  labelText: 'Buscar Servicio', suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: Consumer<ServicioProvider>(
                builder: (context, servicioProvider, child) {
              return ListView.builder(
                  itemCount: servicioProvider.servicios.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: InkWell(
                            onTap: () {},
                            child: ListTile(
                                title: Text('Titulo'),
                                subtitle: Text('Subtitulo'))));
                  });
            }),
          )
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NuevoServicio()));
        },
      ),
    );
  }
}

class NuevoServicio extends StatefulWidget {
  @override
  _NuevoServicioState createState() => _NuevoServicioState();
}

class _NuevoServicioState extends State<NuevoServicio> {
  List<String> _listaEstado = [
    'INSPECCION',
    'COTIZACION',
    'PROCESO',
    'FINALIZADO CON OBSERVACIONES',
    'FINALIZADO SIN OBSERVACIONES',
    'SUSPENDIDO',
    'POSTERGADO',
  ];
  List<String> _listaDescripcion = [
    'INSTALACION DE UN SECTOR CON POCO ACCESO A ELECTRICIDAD',
    'INSTALACION RELIZADO CORRECTAMENTE',
    'INSTALACION ES UN DESASTRE',
    'S/N',
    'SUSPENDIDO',
    'POSPUESTO',
  ];
  Map<String, dynamic> _servicioState = {
    'id': nanoid(10),
    'estado': 'COTIZACION',
    'descripcion': 'INSTALACION DE UN SECTOR CON POCO ACCESO A ELECTRICIDAD'
  };
  TecnicoDetalle? _tecnico;
  ServicioTipo? _servicioTipo;
  Cliente? _cliente;
  ServicioDetalle? servicioDetalle;

  final List<Map<String, dynamic>> _equiposState = [];
  List<Equipo> _equipos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Servicio'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.receipt)),
          IconButton(
              onPressed: () {}, color: Colors.yellow, icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {}, color: Colors.red, icon: Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('DATOS DE NUEVO SERVICIO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
            ListTile(
              title: Text(_cliente?.nombreCompleto != null
                  ? 'Cliente: ${_cliente?.nombreCompleto}'
                  : "Seleccione cliente"),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () => _selectCliente(context),
            ),
            ListTile(
              title: Text(_servicioTipo?.tipo != null
                  ? 'Tipo de Servicio: ${_servicioTipo?.tipo}'
                  : "Seleccione tipo"),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () => _selectServicioTipo(context),
            ),
            ListTile(
              title: Text(_tecnico?.especialidad != null
                  ? 'Responsable: ${_tecnico?.id_empleado?.nombreCompleto}'
                  : "Seleccione técnico"),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () => _selectTecnico(context),
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _listaDescripcion
                    .where((String option) => option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ))
                    .toList();
              },
              onSelected: (String selected) {
                setState(() {
                  _servicioState['descripcion'] = selected;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Selecciona o escribe',
                  ),
                );
              },
              displayStringForOption: (String option) => option,
            ),
            DropdownButtonFormField(
              value: _servicioState['estado'] as String,
              onChanged: (String? newValue) {
                setState(() {
                  _servicioState['estado'] = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecciona el estado';
                }
                return null;
              },
              items: _listaEstado.map((String estado) {
                return DropdownMenuItem<String>(
                  value: estado,
                  child: Text(estado),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('LISTA DE EQUIPOS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
            Column(
              children: _equipos.asMap().entries.map((entry) {
                final index = entry.key;
                final equipo = entry.value;
                final cantidad = _equiposState.length > index
                    ? _equiposState[index]['cantidad']
                    : 0;

                // Verificar si equipo.stock o equipo.precio son nulos
                final stock = equipo.stock ?? 0;
                final precio = equipo.precio ?? 0;

                final disponibilidad = stock - cantidad;
                final costoTotal = precio * cantidad;

                // setState(() {
                //   if (index == 0) _ventaState['total'] = 0.0;
                //   _ventaState['total'] =
                //       (_ventaState['total'] ?? 0.0) + costoTotal.toDouble();
                // });

                return Container(
                    color: Theme.of(context).cardColor,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Equipo: ${equipo.nombre}'),
                            Text(
                                'Disponible: ${disponibilidad >= 0 ? disponibilidad : 0}'),
                            Text('Costo: $costoTotal'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Cantidad: $cantidad'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (_equiposState.length > index) {
                                    if (disponibilidad > 0) {
                                      _equiposState[index]['cantidad']++;
                                    }
                                  } else {
                                    _equiposState[index]['cantidad'] = 1;
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_equiposState.length > index &&
                                      _equiposState[index]['cantidad'] > 0) {
                                    _equiposState[index]['cantidad']--;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ));
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('LISTA DE TAREAS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Servicio: _ventaState[]',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark),
                  ),
                  onPressed: () {
                    // if (_cliente?.id == null || _equiposState.isEmpty) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: Text('Advertencia!!!'),
                    //         content: Text(
                    //             'Debe seleccionar un cliente o los equipos'),
                    //         actions: [
                    //           TextButton(
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: Text('Aceptar'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    // } else {
                    //   VentaDetalleProvider().createVenta(
                    //       nuevaVenta: _ventaState,
                    //       nuevaCotizacion: _cotizacionState,
                    //       nuevosEquipos: _equiposState,
                    //       nuevaCotizacionVenta: _cotizacionVentaState);
                    //   Navigator.of(context).pop();
                    //   print('Venta guardada');
                    // }
                  },
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.0),
          ],
        ),
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _selectTarea(context);
            },
            child: Icon(Icons.add_task),
          ),
          SizedBox(width: 16.0), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              _selectEquipos(context);

              // Lógica para el segundo botón flotante
              // ...
            },
            child: Icon(
                Icons.add_box), // Reemplaza "another_icon" con el icono deseado
          ),
        ],
      ),
    );
  }

  void _selectTarea(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Agregar Tarea'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: TareaNueva(servicioDetalle),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _selectEquipos(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AgregarEquipo(
          onEquipoSelected: (Equipo equipo) {
            setState(() {
              final index =
                  _equipos.indexWhere((element) => equipo.id == element.id);
              if (index < 0) {
                _equipos.add(equipo);
                print('equipossSate: ${_equiposState}');
                print('cantidad: ${equipo.toMap()}');
                _equiposState.add({
                  'id': nanoid(10),
                  'id_servicio': _servicioState['id'],
                  'id_equipo': equipo.id,
                  'cantidad': 0,
                  'unidad': 'UNIDAD'
                });
              }
            });
          },
        );
      },
    );
  }

  void _selectCliente(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioClienteBox(onClienteSelected: (Cliente cliente) {
            setState(() {
              _cliente = cliente;
            });
          });
        });
  }

  void _selectServicioTipo(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioTipoBox(
              onServicioTipoSelected: (ServicioTipo servicioTipo) {
            setState(() {
              _servicioTipo = servicioTipo;
            });
          });
        });
  }

  void _selectTecnico(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioTecnicoBox(
              onTecnicoSelected: (TecnicoDetalle tecnico) {
            setState(() {
              _tecnico = tecnico;
              _servicioState['id_tecnico'] = tecnico.id;
            });
          });
        });
  }
}

class ServicioTecnicoBox extends StatefulWidget {
  final Function(TecnicoDetalle) onTecnicoSelected;

  ServicioTecnicoBox({required this.onTecnicoSelected});

  @override
  _ServicioTecnicoBoxState createState() => _ServicioTecnicoBoxState();
}

class _ServicioTecnicoBoxState extends State<ServicioTecnicoBox> {
  late Future<void> _dataLoadingFuture;
  @override
  void initState() {
    super.initState();
    // Llama a localTecnico() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<EmpleadoProvider>(context, listen: false)
        .getAllTecnicos();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Seleccione Técnico Responsable'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<EmpleadoProvider>(
              builder: (context, tecnicoProvider, child) {
                print(
                    'tecnicoccccc ${tecnicoProvider.tecnicos[0].id_empleado?.nombres}');
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: tecnicoProvider.tecnicos.length,
                    itemBuilder: (context, index) {
                      TecnicoDetalle tecnico = tecnicoProvider.tecnicos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            tecnico.especialidad ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: tecnico.id_empleado?.nombreCompleto != null
                              ? Text(tecnico.id_empleado?.nombreCompleto! ?? '')
                              : null,
                          onTap: () {
                            widget.onTecnicoSelected(tecnico);
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
    );
  }
}

class ServicioTipoBox extends StatefulWidget {
  final Function(ServicioTipo) onServicioTipoSelected;

  ServicioTipoBox({required this.onServicioTipoSelected});

  @override
  _ServicioTipoBoxState createState() => _ServicioTipoBoxState();
}

class _ServicioTipoBoxState extends State<ServicioTipoBox> {
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Llama a localServicioTipo() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ServicioProvider>(context, listen: false)
        .getAllServicioTipos();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Selecciona Tipo'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ServicioProvider>(
              builder: (context, servicioProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: servicioProvider.servicioTipo.length,
                    itemBuilder: (context, index) {
                      ServicioTipo servicioTipo =
                          servicioProvider.servicioTipo[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            servicioTipo.tipo ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: servicioTipo.descripcion != null
                              ? Text(servicioTipo.descripcion!)
                              : null,
                          onTap: () {
                            widget.onServicioTipoSelected(servicioTipo);
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
    );
  }
}

class ServicioClienteBox extends StatefulWidget {
  final Function(Cliente) onClienteSelected;

  ServicioClienteBox({required this.onClienteSelected});

  @override
  _ServicioClienteBoxState createState() => _ServicioClienteBoxState();
}

class _ServicioClienteBoxState extends State<ServicioClienteBox> {
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Llama a localCliente() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ClienteProvider>(context, listen: false).getAllClientes();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Selecciona Cliente'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ClienteProvider>(
              builder: (context, clienteProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: clienteProvider.clientes.length,
                    itemBuilder: (context, index) {
                      Cliente cliente = clienteProvider.clientes[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            cliente.nombres ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: cliente.apellidoPaterno != null
                              ? Text(cliente.apellidoMaterno!)
                              : null,
                          onTap: () {
                            widget.onClienteSelected(cliente);
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
    );
  }
}

class AgregarEquipo extends StatefulWidget {
  final Function(Equipo) onEquipoSelected;

  AgregarEquipo({required this.onEquipoSelected});

  @override
  _AgregarEquipoState createState() => _AgregarEquipoState();
}

class _AgregarEquipoState extends State<AgregarEquipo> {
  late EquipoProvider _EquipoProvider;
  TextEditingController _searchController = TextEditingController();
  List<EquipoDetalle> _filteredEquipos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _EquipoProvider = Provider.of<EquipoProvider>(context, listen: false);
    _filteredEquipos = _EquipoProvider.equipoDetalle;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text('Seleccionar Equipo'),
          SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: _filterEquipos,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre',
            ),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Consumer<EquipoProvider>(
          builder: (context, EquipoProvider, child) {
            return ListView.builder(
              itemCount: _filteredEquipos.length,
              itemBuilder: (context, index) {
                EquipoDetalle equipo = _filteredEquipos[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      widget.onEquipoSelected(equipo);
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(equipo.nombre ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Proveedor: ${equipo.proveedors?.nombre}'),
                              Text('Stock: ${equipo.stock}'),
                              Text('Precio: ${equipo.precio}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _filterEquipos(String searchTerm) {
    setState(() {
      // Filtrar la lista de clientes basándose en el nombre completo
      _filteredEquipos = _EquipoProvider.equipoDetalle
          .where((equipo) => (equipo.nombre?.toLowerCase() ?? '')
              .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }
}
