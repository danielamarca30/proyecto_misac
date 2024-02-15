import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Proveedores
import 'package:movil/servicios/loginProvider.dart';
import 'package:movil/theme/theme.dart';
import 'package:movil/ventanas/HomeWindow.dart';

class Login extends StatefulWidget {
  final String titulo;
  const Login({super.key, required this.titulo});
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String _mensajeInicio = '';
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    // Agrega un listener para detectar cambios en el MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showImage = MediaQuery.of(context).viewInsets.bottom == 0;
      });
    });
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    int isLoggedIn = await provider.login('daniel', 'daniel');
    //     int isLoggedIn = await provider.login(
    // _usuarioController.text, _contrasenaController.text);
    switch (isLoggedIn) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainHome(user: provider.usuario?.username ?? 'NombreGenérico'),
          ),
        );
        break;
      case 1:
        setState(() {
          _mensajeInicio = "Usuario o contraseña incorrecta";
        });
        break;
      case 2:
        setState(() {
          _mensajeInicio = "Error de conexión con el servidor...!";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    if (_showImage && keyboardOpen) {
      _showImage = false;
    } else if (!_showImage && !keyboardOpen) {
      _showImage = true;
    }

    return Scaffold(
        backgroundColor:
            HexColor.fromHex("#181a1f"), // Establece el color de fondo aquí
        body: Stack(
          children: [
            DarkRadialBackground(
                color: HexColor.fromHex("#181a1f"), position: "topLeft"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    if (_showImage)
                      Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.2,
                              colors: <Color>[Colors.black, Colors.transparent],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.asset("./assets/logo.png",
                              width: 200, height: 200),
                        ),
                      ),
                    Text(
                      'Ingreso',
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style:
                            GoogleFonts.lato(color: HexColor.fromHex("676979")),
                        children: const <TextSpan>[
                          TextSpan(
                              text: "Ingrese usuario y contraseña",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Usuario".toUpperCase(),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: HexColor.fromHex("FFFFFF"))),
                    TextFormField(
                      controller: _usuarioController,
                      onTap: () {},
                      style: GoogleFonts.lato(
                          color: HexColor.fromHex("FFFFFF"),
                          fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    Text("Contraseña".toUpperCase(),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: HexColor.fromHex("FFFFFF"))),
                    TextFormField(
                      controller: _contrasenaController,
                      onTap: () {},
                      style: GoogleFonts.lato(
                          color: HexColor.fromHex("FFFFFF"),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFFE3B23C)),
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(width: 1.0)))),
                            onPressed: _handleLogin,
                            child: Text("Ingresar",
                                style: GoogleFonts.lato(
                                    fontSize: 20, color: Colors.white)))),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              _mensajeInicio,
                              style: GoogleFonts.lato(
                                  color: Colors.redAccent, fontSize: 17),
                            ))),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
