import 'package:flutter/material.dart';
import 'package:movil/servicios/clienteProvider.dart';
import 'package:movil/servicios/equipoProvider.dart';
import 'package:movil/servicios/proveedorProvider.dart';
import 'package:provider/provider.dart';
// Componentes
import 'package:movil/servicios/loginProvider.dart';
import 'package:movil/ventanas/login/main.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => ClienteProvider()),
    ChangeNotifierProvider(create: (_) => EquipoProvider()),
    ChangeNotifierProvider(create: (_) => ProveedorProvider()),
  ], child: const Proyecto()));
}

class Proyecto extends StatefulWidget {
  const Proyecto({Key? key}) : super(key: key);
  @override
  _ProyectoState createState() => _ProyectoState();
}

class _ProyectoState extends State<Proyecto> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto de Grado',
      theme: ThemeData(
        // Tema Claro
        brightness: Brightness.light,
        primaryColor: Color(0xFFE3B23C),
        scaffoldBackgroundColor: Color(0xFFF0EDE5),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFE3B23C),
          secondary: Color(0xFFE3B23C), // Sustituye el antiguo accentColor
          error: Color(0xFFBA1B1B), // Rojo para errores
          // Define otros colores del esquema si lo deseas
        ),
        // Aquí puedes definir colores personalizados adicionales
      ),
      darkTheme: ThemeData(
        // Tema Oscuro
        brightness: Brightness.dark,
        primaryColor: Color(0xFF081A2B),
        scaffoldBackgroundColor: Color(0xFF2A2C2B),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFE3B23C),
          secondary: Color(0xFFE3B23C), // Sustituye el antiguo accentColor
          error: Color(0xFFCF6679), // Rojo oscuro para errores
          // Define otros colores del esquema si lo deseas
        ),
        // Aquí puedes definir colores personalizados adicionales
      ),
      home: const Login(titulo: 'proyecto'),
    );
  }
}
