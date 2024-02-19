import 'package:flutter/material.dart';
//Local
import 'package:movil/theme/theme.dart';
import 'package:movil/modelos/empleado.dart';
import 'package:movil/ventanas/empleados/detalle.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:movil/elementos/bottomNavigator.dart';
import 'package:movil/servicios/empleadoProvider.dart';
import 'package:movil/elementos/Input.dart';

class EmpleadoWindow extends StatefulWidget {
  @override
  _EmpleadoWindowState createState() => _EmpleadoWindowState();
}

class _EmpleadoWindowState extends State<EmpleadoWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("383a3f"),
      appBar: AppBar(title: const Text("Empleados")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (String a) {
                  //no se hace nada implementar
                },
                decoration: InputDecoration(
                  labelText: 'Buscar Empleados',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(child: Consumer<EmpleadoProvider>(
                builder: (context, servicioEmpleadoProvider, child) {
              return ListView.builder(
                  itemCount: servicioEmpleadoProvider.empleados.length,
                  itemBuilder: (context, index) {
                    Empleado empleado =
                        servicioEmpleadoProvider.empleados[index];
                    return Card(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleEmpleado(empleado)));
                            },
                            child: ListTile(
                              title: Text(empleado.nombres ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${empleado.apellidoPaterno} ${empleado.apellidoMaterno}',
                                  ),
                                  Text(
                                      'Dirección: ${empleado.direccion ?? 'N/A'}'),
                                  Text(
                                      'Telefono: ${empleado.telefono ?? 'N/A'}'),
                                  Text('Rol: ${empleado.rol ?? 'N/A'}'),
                                ],
                              ),
                            )));
                  });
            }))
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NuevoEmpleado()));
        },
      ),
    );
  }
}

class NuevoEmpleado extends StatefulWidget {
  @override
  _NuevoEmpleadoState createState() => _NuevoEmpleadoState();
}

class _NuevoEmpleadoState extends State<NuevoEmpleado> {
  final _nombresController = TextEditingController();
  final _salarioController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  List<String> _roles = [
    'TECNICO',
    'GERENTE',
    'AUXILIAR GERENTE',
    'VENTAS',
    'LOGISTICA',
  ];
  String _selectedRol = 'TECNICO';
  List<String> _especialidadTecnico = [
    'INSTALACION',
    'MANTENIMIENTO',
  ];
  String _selectedEspecialiadTecnico = 'INSTALACION';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                    controller: _nombresController, label: 'Nombres'),
                CustomTextField(
                    controller: _apellidoPaternoController,
                    label: 'Apellido Paterno'),
                CustomTextField(
                    controller: _apellidoMaternoController,
                    label: 'Apellido Materno'),
                CustomTextField(
                    controller: _ciController, label: 'Carnet Identidad'),
                CustomTextField(
                  controller: _direccionController,
                  label: 'Dirección',
                  maxLines: 2,
                ),
                CustomTextField(
                    controller: _telefonoController, label: 'Telefono'),
                CustomTextField(controller: _correoController, label: 'Correo'),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Rol',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRol,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRol = newValue!;
                      });
                    },
                    items: _roles.map((String rol) {
                      return DropdownMenuItem<String>(
                        value: rol,
                        child: Text(rol),
                      );
                    }).toList(),
                    hint: Text('Selecciona un Rol'),
                  ),
                ),
                if (_selectedRol == 'TECNICO')
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Especialidad',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (_selectedRol == 'TECNICO')
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedEspecialiadTecnico,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEspecialiadTecnico = newValue!;
                        });
                      },
                      items: _especialidadTecnico.map((String especialidad) {
                        return DropdownMenuItem<String>(
                          value: especialidad,
                          child: Text(especialidad),
                        );
                      }).toList(),
                      hint: Text('Selecciona un Especialidad'),
                    ),
                  ),
                CustomTextField(
                  controller: _salarioController,
                  label: 'Salario',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submit(context);
                  },
                  child: Text('Registrar Empleado'),
                )
              ],
            ),
          ),
        ));
  }

  void _submit(BuildContext context) async {
    try {
      double? salario = double.tryParse(_salarioController.text ?? '0');
      final empleadoId = nanoid(10);
      Empleado empleado = Empleado(
        id: empleadoId,
        rol: _selectedRol ?? '',
        salario: salario,
        nombres: _nombresController.text ?? '',
        apellidoPaterno: _apellidoPaternoController.text ?? '',
        apellidoMaterno: _apellidoMaternoController.text ?? '',
        nombreCompleto:
            "${_nombresController.text ?? ''} ${_apellidoPaternoController.text ?? ''} ${_apellidoMaternoController.text ?? ''}",
        direccion: _direccionController.text ?? '',
        telefono: _telefonoController.text ?? '',
        ci: _ciController.text ?? '',
        correo: _correoController.text ?? '',
      );
      await EmpleadoProvider().createEmpleado(empleado);
      final index = _roles.indexOf(_selectedRol);
      if (index == 0) {
        final tecnicoId = nanoid(10);
        Tecnico tecnico = Tecnico(
            id: tecnicoId,
            especialidad: _selectedEspecialiadTecnico,
            id_empleado: empleadoId);
        await EmpleadoProvider().createTecnico(tecnico);
      }
      Navigator.of(context).pop();
    } catch (e) {}
  }
}
