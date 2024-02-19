import 'package:flutter/material.dart';
import 'package:movil/modelos/servicio.dart';
import 'package:movil/modelos/cliente.dart';
import 'package:movil/modelos/empleado.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
// import 'package:movil/componentes/Servicio/servicioTipo.dart';
// import 'package:movil/componentes/Servicio/Cliente/servicioCliente.dart';
// import 'package:movil/componentes/Servicio/Tecnico/servicioTecnico.dart';
// import 'package:movil/provider/servicioEmpleadoProvider.dart';

import 'package:movil/servicios/empleadoProvider.dart';
import 'package:movil/servicios/servicioProvider.dart';
import 'package:movil/servicios/clienteProvider.dart';

class TareaNueva extends StatefulWidget {
  ServicioDetalle? servicioDetalle;
  TareaNueva(this.servicioDetalle);
  @override
  _TareaNuevaState createState() => _TareaNuevaState();
}

class _TareaNuevaState extends State<TareaNueva> {
  late ServicioProvider _ServicioProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioProvider = Provider.of<ServicioProvider>(context, listen: false);
  }

  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _comentarioController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  ServicioTipo? _servicioTipo;
  TecnicoDetalle? _tecnico;
  Cliente? _cliente;
  double? _costo;

  List<String> _estado = [
    'COTIZACION',
    'INICIO',
    'PROCESO',
    'FINALIZADO SIN OBSERVACIONES',
    'FINALIZADO CON OBSERVACIONES',
    'CANCELADO'
  ];

  String _selectedEstado = 'COTIZACION';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField(
                value: _selectedEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEstado = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona el estado';
                  }
                  return null;
                },
                items: _estado.map((String rol) {
                  return DropdownMenuItem<String>(
                    value: rol,
                    child: Text(rol),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'costo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la costo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _comentarioController,
                decoration: InputDecoration(labelText: 'Comentarios'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el comentario';
                  }
                  return null;
                },
              ),
              buildElevatedButton(
                  'Seleccionar Fecha Inicio', _selectDateAndTimeInicio),
              buildInfoText('Fecha Inicio', _fechaInicio),
              buildElevatedButton(
                  'Seleccionar Fecha Fin', _selectDateAndTimeFin),
              buildInfoText('Fecha Fin', _fechaFin),
              ElevatedButton(
                onPressed: () {
                  _submit(context);
                },
                child: Text('Registrar Servicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTecnico(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioTecnicoBox(
              onTecnicoSelected: (TecnicoDetalle tecnico) {
            setState(() {
              _tecnico = tecnico;
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

  ElevatedButton buildElevatedButton(String label, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Text buildInfoText(String label, DateTime? dateTime) {
    return Text(
      dateTime != null ? '$label: ${_formatDateTime(dateTime)}' : '',
      style: TextStyle(fontSize: 16),
    );
  }

  Future<void> _selectDateAndTimeInicio() async {
    final pickedDateTime = await _selectDateAndTime(context, _fechaInicio);
    print('datee ${pickedDateTime}');
    if (pickedDateTime != null) {
      setState(() {
        _fechaInicio = pickedDateTime;
      });
    }
  }

  Future<void> _selectDateAndTimeFin() async {
    final pickedDateTime = await _selectDateAndTime(context, _fechaFin);
    print('datee ${pickedDateTime}');
    if (pickedDateTime != null) {
      setState(() {
        _fechaFin = pickedDateTime;
      });
    }
  }

  Future<DateTime?> _selectDateAndTime(
      BuildContext context, DateTime? initialDateTime) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    print('datee: ${pickedDateTime}');

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );
      print('hora ${pickedTime}');

      if (pickedTime != null) {
        pickedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return pickedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ';
  }

  void _submit(BuildContext context) async {
    // if (_formKey.currentState!.validate()) {
    //   print('hola ${_servicioTipo?.tipo}');
    //   try {
    //     String url = '${Server().url}/servicio';
    //     Servicio servicio = Servicio(
    //       id: '',
    //       id_cliente: _cliente?.id,
    //       id_tecnico: _tecnico?.id,
    //       id_servicio_tipo: _servicioTipo?.id,
    //       estado: _selectedEstado,
    //       descripcion: _descripcionController.text,
    //       fechaInicio: _fechaInicio,
    //       fechaFin: _fechaFin,
    //     );
    //     Map<String, dynamic> servicioMap = servicio.toMap();
    //     servicioMap.remove('nombreCompleto');
    //     if (servicio.fechaFin == null) servicioMap.remove('fechaFin');
    //     if (servicio.fechaInicio == null) servicioMap.remove('fechaInicio');
    //     if (servicio.fechaProgramada == null)
    //       servicioMap.remove('fechaProgramada');
    //     print('envio de datos ${servicioMap}');
    //     final response = await Dio().post(
    //       url,
    //       data: json.encode(servicioMap),
    //       options: Options(
    //         headers: {'Content-Type': 'application/json'},
    //       ),
    //     );
    //     if (response.statusCode != 200) throw Exception('Error de técnico');
    //     await _ServicioProvider.syncServicioTipo();
    //     await _ServicioProvider.syncServicio();
    //     Navigator.of(context).pop();
    //   } catch (e) {
    //     if (e is DioError &&
    //         e.response != null &&
    //         e.response!.statusCode == 409) {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             backgroundColor: Colors.red,
    //             title: Text('Error al registrar Tarea'),
    //             content: Text(
    //               'Servicio duplicado. Por favor, verifica la información e intenta nuevamente.',
    //             ),
    //             actions: <Widget>[
    //               TextButton(
    //                 child: Text('Cerrar'),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     } else {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             backgroundColor: Colors.red,
    //             title: Text('Error al registrar Servicio'),
    //             content: Text(
    //               'Se produjo un error al intentar registrar al cliente. Por favor, inténtalo nuevamente.',
    //             ),
    //             actions: <Widget>[
    //               TextButton(
    //                 child: Text('Cerrar'),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     }
    //   }
    // }
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
