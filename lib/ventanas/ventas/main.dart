import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movil/servicios/clienteProvider.dart';
import 'package:movil/servicios/equipoProvider.dart';
import 'package:movil/servicios/loginProvider.dart';
import 'package:movil/servicios/ventaDetalleProvider.dart';
import 'package:movil/servicios/ventaProvider.dart';
import 'package:nanoid/nanoid.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:provider/provider.dart';
//Loca
import 'package:movil/elementos/bottomNavigator.dart';
import 'package:movil/modelos/empleado.dart';
import 'package:movil/modelos/cliente.dart';
import 'package:movil/modelos/equipo.dart';
import 'package:movil/modelos/venta.dart';
import 'package:movil/modelos/cotizacion.dart';

class VentaWindow extends StatefulWidget {
  @override
  _VentaWindowState createState() => _VentaWindowState();
}

class _VentaWindowState extends State<VentaWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ventas'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String query) {},
              decoration: InputDecoration(
                labelText: 'Buscar Venta',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<VentaProvider>(
              builder: (context, servicioVentaProvider, child) {
                print('servicioCliente: ${servicioVentaProvider.ventas}');
                return ListView.builder(
                  itemCount: servicioVentaProvider.ventas.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> venta =
                        servicioVentaProvider.ventas[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DetalleEquipo(venta),
                          //   ),
                          // );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              // Espaciado entre la imagen y el texto
                              Text(venta['total'].toString() ?? ''),
                            ],
                          ),
                          subtitle: Text(
                            '${venta['estado']}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NuevaVenta(),
              ));
        },
      ),
    );
  }
}

class NuevaVenta extends StatefulWidget {
  @override
  _NuevaVentaState createState() => _NuevaVentaState();
}

class _NuevaVentaState extends State<NuevaVenta> {
  List<String> _listaTipoVenta = ['EN LINEA', 'FISICA'];
  List<String> _listaEstado = [
    'COMPLETADO',
    'EN PROCESO',
    'CANCELADO',
    'REEMBOLSO',
    'ENTREGADO'
  ];
  Cliente? _cliente;
  Map<String, dynamic> _ventaState = {
    'id': nanoid(10),
    'id_empleado': LoginProvider().usuario?.id_empleado,
    'id_cliente': '',
    'estado': 'COMPLETADO',
    'tipo': 'FISICA',
    'fecha': DateTime.now().toString(),
    'total': 0,
  };
  Map<String, dynamic> _cotizacionState = {};
  Map<String, dynamic> _cotizacionVentaState = {};

  final List<Map<String, dynamic>> _equiposState = [];
  List<Equipo> _equipos = [];
  @override
  void initState() {
    super.initState();
    EquipoProvider().getAllEquipoDetalles();
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              if (_cliente?.id == null || _equiposState.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Advertencia!!!'),
                      content:
                          Text('Debe seleccionar un cliente o los equipos'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                sharePdf();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () {
              // Lógica para imprimir comprobante de venta
              print('Imprimir Comprobante de Venta');
            },
          ),
          SizedBox(
            width: 30,
          ),
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Lógica para imprimir cotización
              print('Modificar');
            },
          ),
          IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Lógica para imprimir comprobante de venta
              print('Eliminar');
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Cliente:'),
          ListTile(
            title: Text(
              _cliente?.nombreCompleto != null
                  ? '${_cliente?.nombreCompleto}'
                  : 'Seleccione cliente',
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              _selectCliente(context);
            },
          ),
          const SizedBox(height: 8.0),
          const Text('Tipo venta'),
          Container(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
            child: DropdownButton<String>(
              value: _ventaState['tipo'] ?? _listaTipoVenta[0],
              items: _listaTipoVenta.map((String item) {
                return DropdownMenuItem<String>(
                  child: Text(item),
                  value: item,
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _ventaState['tipo'] = newValue;
                });
              },
            ),
          ),
          const SizedBox(height: 8.0),
          const Text('Estado de venta'),
          Container(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
            child: DropdownButton<String>(
              value: _ventaState['estado'] ?? _listaEstado[0],
              items: _listaEstado.map((String item) {
                return DropdownMenuItem<String>(
                  child: Text(item),
                  value: item,
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _ventaState['estado'] = newValue;
                });
              },
            ),
          ),
          SizedBox(height: 8.0),
          Text('LISTA DE EQUIPOS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          SizedBox(height: 8.0),
          Column(
            children: [
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

                  setState(() {
                    if (index == 0) _ventaState['total'] = 0.0;
                    _ventaState['total'] =
                        (_ventaState['total'] ?? 0.0) + costoTotal.toDouble();
                  });

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Costo Total: ${_ventaState['total']}',
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
                      if (_cliente?.id == null || _equiposState.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Advertencia!!!'),
                              content: Text(
                                  'Debe seleccionar un cliente o los equipos'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        VentaDetalleProvider().createVenta(
                            nuevaVenta: _ventaState,
                            nuevaCotizacion: _cotizacionState,
                            nuevosEquipos: _equiposState,
                            nuevaCotizacionVenta: _cotizacionVentaState);
                        Navigator.of(context).pop();
                        print('Venta guardada');
                      }
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
            ],
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          _selectEquipos(context);
        },
      ),
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
                  'id_venta': _ventaState['id'],
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
      builder: (BuildContext dialogContext) {
        return ClienteDialog(
          onClienteSelected: (Cliente cliente) {
            setState(() {
              _cliente = cliente;
              _ventaState['id_cliente'] = cliente.id;
            });
          },
        );
      },
    );
  }

  Future<Uint8List> generatePdf() async {
    // Obtén el contenido del logotipo de la empresa
    final ByteData logoByteData = await rootBundle.load('assets/logo.png');
    final Uint8List logo = logoByteData.buffer.asUint8List();
    // Crear el documento PDF
    final pdf = pw.Document();
    // Agregar una página al documento
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Sección superior derecha con logo e información de la empresa
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    margin: pw.EdgeInsets.only(top: 10, right: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Image(pw.MemoryImage(logo), width: 50, height: 50),
                        pw.Text('MISAC',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Oruro, Calle Murguia esquina Adolfo Mier #6',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Teléfono: +591 73803755',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              // Espacio entre la sección superior y los detalles de la cotización
              pw.SizedBox(height: 20),
              // Detalles de la cotización
              pw.Center(
                child: pw.Text('COTIZACIÓN',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),

              // Detalles del cliente
              pw.Text('Cliente: ${_cliente?.nombreCompleto ?? "N/A"}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Fecha: ${DateTime.now()}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              pw.Text('Detalle:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              if (_equipos.isNotEmpty && _equiposState.isNotEmpty)
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FixedColumnWidth(200), // Ancho de la primera columna
                    1: pw.FixedColumnWidth(100), // Ancho de la segunda columna
                    2: pw.FixedColumnWidth(100), // Ancho de la tercera columna
                    3: pw.FixedColumnWidth(100), // Ancho de la cuarta columna
                  },
                  children: [
                    // Encabezado de la tabla
                    pw.TableRow(
                      children: [
                        pw.Text('Equipo [Descripción]',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Cantidad [Unidades]',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Precio Unitario [Bs]',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Precio Total [Bs]',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    // Detalles de los equipos
                    for (var i = 0; i < _equipos.length; i++)
                      pw.TableRow(
                        children: [
                          pw.Text(_equipos[i].nombre ?? 'N/A',
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(_equiposState[i]['cantidad'].toString(),
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              '${_equipos[i]?.precio?.toStringAsFixed(2)}', // Muestra dos decimales
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                            '${((_equipos[i]?.precio ?? 0.0) * (_equiposState[i]['cantidad'] ?? 0.0)).toStringAsFixed(2)}', // Muestra dos decimales
                            style: pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    pw.TableRow(children: [
                      pw.Text('Total: ',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Container(),
                      pw.Container(),
                      pw.Text(
                          '${_ventaState['total']?.toStringAsFixed(2)} [Bs]',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ])
                  ],
                ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    // Devolver el PDF como una lista de bytes
    return pdf.save();
  }

  Future<void> sharePdf() async {
    // {
    //     'id':1,
    //     'id_cliente':1,
    //     'id_empleado':1,
    //     'monto':2,
    //     'estado':2
    // };
    final cotizacionId = nanoid(10);
    _cotizacionState = {
      'id': cotizacionId,
      'id_cliente': _cliente?.id ?? '',
      'id_empleado': LoginProvider().usuario?.id_empleado,
      'monto': _ventaState['total'],
      'estado': 'TERMINADO'
    };
    DateTime fechaCreacion = DateTime.now();
    DateTime fechaValidez = fechaCreacion.add(Duration(days: 1));

    _cotizacionVentaState = {
      'id': nanoid(10),
      'id_cotizacion': cotizacionId,
      'id_venta': _ventaState['id'],
      'fechaCreacion': fechaCreacion.toString(),
      'fechaValidez': fechaValidez.toString(),
      'monto': _ventaState['total'],
      'estado': 'TERMINADO'
    };

    // Genera el PDF y obtén los bytes
    final Uint8List pdfBytes = await generatePdf();

    // Comparte el archivo PDF
    await Share.file(
      'Cotizacion',
      'cotizacion.pdf',
      pdfBytes,
      'application/pdf',
      text: '¡Revisa esta cotización!',
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

class ClienteDialog extends StatefulWidget {
  final Function(Cliente) onClienteSelected;

  ClienteDialog({required this.onClienteSelected});

  @override
  _ClienteDialogState createState() => _ClienteDialogState();
}

class _ClienteDialogState extends State<ClienteDialog> {
  late ClienteProvider _servicioVentaProvider;
  TextEditingController _searchController = TextEditingController();
  List<Cliente> _filteredClientes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _servicioVentaProvider =
        Provider.of<ClienteProvider>(context, listen: false);

    // Inicializar la lista filtrada con todos los clientes al principio
    _filteredClientes = _servicioVentaProvider.clientes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text('Seleccionar Cliente'),
          SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: _filterClientes,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre completo',
            ),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Consumer<ClienteProvider>(
          builder: (context, servicioVentaProvider, child) {
            return ListView.builder(
              itemCount: _filteredClientes.length,
              itemBuilder: (context, index) {
                Cliente cliente = _filteredClientes[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      widget.onClienteSelected(cliente);
                      Navigator.of(context).pop();
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
                              Text('Dirección: ${cliente.direccion}'),
                              Text('Teléfono: ${cliente.telefono}'),
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

  void _filterClientes(String searchTerm) {
    setState(() {
      _filteredClientes = _servicioVentaProvider.clientes
          .where((cliente) => (cliente.nombreCompleto?.toLowerCase() ?? '')
              .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }
}

// class VentaProvider extends ChangeNotifier {
//   late Venta _venta;
//   late List<VentaEquipo> _ventaEquipo;
//   late CotizacionVenta _cotizacionVenta;
//   // late LogginProvider _logginProvider;
//   Venta get venta => _venta;
//   List<VentaEquipo> get ventaEquipo => _ventaEquipo;
//   CotizacionVenta get cotizacionVenta => _cotizacionVenta;
//   void addVentaEquipo(VentaEquipo ventaEquipo) {
//     final index = _ventaEquipo
//         .indexWhere((element) => ventaEquipo.id_equipo == element.id_equipo);
//     if (index < 0) {
//       _ventaEquipo.add(ventaEquipo);
//       notifyListeners();
//     }
//   }

//   void removeVentaEquipo(VentaEquipo ventaEquipo) {
//     final index = _ventaEquipo
//         .indexWhere((element) => ventaEquipo.id_equipo == element.id_equipo);
//     if (index >= 0) {
//       _ventaEquipo.removeAt(index);
//       notifyListeners();
//     }
//   }

//   void addCotizacion(CotizacionVenta cotizacionVenta) {
//     _cotizacionVenta = cotizacionVenta;
//     notifyListeners();
//   }

//   void addVenta(Venta venta) {
//     _venta = venta;
//     notifyListeners();
//   }

//   void addVentaAnCliente(Cliente? cliente) {
//     if (cliente?.id != null) {
//       _venta.id_cliente = cliente?.id;
//       notifyListeners();
//     }
//   }
// }
// Map<String, dynamic> dataMap = {
//   "venta": {
//     "id": "2345",
//     "nombre": "nueva Venta",
//     "_": [
//       {
//         "equipos": {
//           "id": "2345",
//           "equipo": "camara XG",
//           "_": [
//             {
//               "pago": {"id": "2345", "monto": 50, "_": null}
//             }
//           ],
//         },
//       },
//       {
//         "equipos": {
//           "id": "3345",
//           "equipo": "camara 234",
//         },
//       },
//       {
//         "pago": {
//           "id": "2345",
//           "monto": 50,
//         }
//       },
//       {
//         "cotizacionVenta": {
//           "id": "2345",
//           "total": 2350,
//           "_": [
//             {
//               "cotizacion": {"nombre": "..."}
//             }
//           ]
//         }
//       }
//     ]
//   }
// };
