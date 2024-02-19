import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Paquetes del proyecto
import 'package:movil/theme/theme.dart';
import 'package:movil/ventanas/empleados/main.dart';
import 'package:movil/ventanas/login/main.dart';

import 'package:movil/ventanas/clientes/main.dart';
import 'package:movil/ventanas/articulos/main.dart';
import 'package:movil/ventanas/servicios/main.dart';
import 'package:movil/ventanas/ventas/main.dart';

class MainHome extends StatefulWidget {
  final String user;
  const MainHome({super.key, required this.user});
  @override
  State<MainHome> createState() => _MainHome();
}

class _MainHome extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          HexColor.fromHex("#181a1f"), // Establece el color de fondo aquí

      appBar: AppBar(
        title: const Text("Menu Principal"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(widget.user.toUpperCase(),
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFFE3B23C)))),
              accountName: Text("Bienvenido ${widget.user}",
                  style: GoogleFonts.lato(fontSize: 22)),
              accountEmail:
                  Text("email:"), // Puedes dejarlo vacío si no lo necesitas
              decoration: BoxDecoration(
                color: Color(0xFFE3B23C),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'Inicio',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Perfil',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Configuraciones',
                  style: GoogleFonts.lato(fontSize: 17)),
              onTap: () {
                // Navega a la pantalla de configuraciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: Text(
                'Cerrar Sesión',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login(titulo: "Inicio")),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: ContentHome(),
      ),
    );
  }
}

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});
  @override
  State<StatefulWidget> createState() => _ContentHome();
}

class _ContentHome extends State<ContentHome> {
  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        SizedBox(height: 20),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Color de fondo claro para el primer elemento
          child: ListTile(
            leading: Icon(Icons.task),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Servicios y Tareas", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de servicios y tareas",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ServicioWindow()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Un tono ligeramente diferente para el segundo elemento
          child: ListTile(
            leading: Icon(Icons.shopping_bag),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Ventas", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de ventas",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VentaWindow()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Alterna los colores para cada elemento
          child: ListTile(
            leading: Icon(Icons.add_box_sharp),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Articulos", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Productos: Equipos, Herramientas, Insumos",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ArticuloWindow()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
            ),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Clientes", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de clientes",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClienteWindow()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
            ),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Empleados", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Empleados , Técnicos",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmpleadoWindow()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    ));
  }
}
