import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movil/elementos/Input.dart';
import 'package:movil/ventanas/articulos/equipos/categoria.dart';
import 'package:movil/ventanas/articulos/equipos/detalle.dart';
import 'package:movil/ventanas/articulos/equipos/proveedor.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//Local
import 'package:movil/servicios/equipoProvider.dart';
import 'package:movil/elementos/bottomNavigator.dart';
import 'package:movil/modelos/equipo.dart';

class EquipoWindow extends StatefulWidget {
  @override
  _EquipoWindowState createState() => _EquipoWindowState();
}

class _EquipoWindowState extends State<EquipoWindow> {
  late Directory? directory;

  @override
  void initState() {
    super.initState();
    getExternalStorageDirectory().then((dir) {
      setState(() {
        directory = dir;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrarEquipos,
              decoration: InputDecoration(
                labelText: 'Buscar Equipo',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<EquipoProvider>(
              builder: (context, servicioClienteProvider, child) {
                print(
                    'servicioCliente: ${servicioClienteProvider.equipos.length}');
                return ListView.builder(
                  itemCount: servicioClienteProvider.equipos.length,
                  itemBuilder: (context, index) {
                    Equipo equipo = servicioClienteProvider.equipos[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleEquipo(equipo),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Image.file(
                                File('${directory?.path}/${equipo.id}.png'),
                                width: 50,
                                height: 60,
                              ),
                              SizedBox(
                                  width:
                                      8.0), // Espaciado entre la imagen y el texto
                              Text(equipo.nombre ?? ''),
                            ],
                          ),
                          subtitle: Text(
                            '${equipo.descripcion}',
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
            MaterialPageRoute(builder: (context) => NuevoEquipo()),
          );
        },
      ),
    );
  }

  void _filtrarEquipos(String query) async {
    if (query.isEmpty) {
      await EquipoProvider().filtrarEquipo(null);
    } else {
      await EquipoProvider().filtrarEquipo(query.toLowerCase());
    }
  }
}

class NuevoEquipo extends StatefulWidget {
  @override
  _NuevoEquipoState createState() => _NuevoEquipoState();
}

class _NuevoEquipoState extends State<NuevoEquipo> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  EquipoCategoria? _id_equipo_categoria;
  Proveedor? _id_proveedor;
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(
              controller: _nombreController,
              label: 'Nombre',
              keyboardType: TextInputType.text),
          CustomTextField(
            controller: _descripcionController,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          CustomTextFieldDecorated(
            controller: _precioController,
            label: 'Precio',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFieldDecorated(
                  controller: _stockController,
                  label: 'Stock',
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _incrementStock(),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _decrementStock(),
              ),
            ],
          ),
          ListTile(
            title: Text(_id_proveedor?.nombre != null
                ? 'Proveedor: ${_id_proveedor?.nombre}'
                : "Seleccione proveedor"),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () => _selectProveedor(context),
          ),
          ListTile(
            title: Text(_id_equipo_categoria?.nombre != null
                ? 'Categoria: ${_id_equipo_categoria?.nombre}'
                : 'Selecione Categoria'),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () => _selectCategoria(context),
          ),
          if (_image != null)
            Image.file(
              _image!,
              width: 200, // Ancho fijo
              height: 200, // Alto fijo
              fit: BoxFit
                  .cover, // Esto asegura que la imagen se recorte si es necesario
            ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Seleccionar Imagen'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _registrarEquipo();
            },
            child: Text('Registrar Cliente'),
          )
        ],
      ),
    );
  }

  void _incrementStock() {
    int currentValue = int.tryParse(_stockController.text) ?? 0;
    _stockController.text = (currentValue + 1).toString();
  }

  void _decrementStock() {
    int currentValue = int.tryParse(_stockController.text) ?? 0;
    currentValue = currentValue > 0 ? currentValue - 1 : 0;
    _stockController.text = currentValue.toString();
  }

  void _selectCategoria(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EquipoCategoriaList(
              onEquipoCategoriaSelected: (EquipoCategoria equipoCategoria) {
            setState(() {
              _id_equipo_categoria = equipoCategoria;
            });
          });
        });
  }

  void _selectProveedor(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProveedorList(onProveedorSelected: (Proveedor proveedor) {
            setState(() {
              _id_proveedor = proveedor;
            });
          });
        });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) return '';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dg9mtscxp/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'olrxmgk6'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    // Aquí reemplaza con la URL de tu endpoint de subida;
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['url'];
    }
    return '';
  }

  Future<void> _saveImageToLocalGallery(String name) async {
    final directory =
        await getExternalStorageDirectory(); // Obtiene el directorio de la galería

    if (_image != null && directory != null) {
      final String filePath = '${directory.path}/${name}.png';
      print('directorio: ${filePath}');
      await _image!.copy(filePath);

      // Puedes guardar la ruta local (filePath) en tu objeto Equipo o hacer lo que necesites.
    }
  }

  Future<void> _registrarEquipo() async {
    double? precio = double.tryParse(_precioController.text);
    int? stock = int.tryParse(_stockController.text);
    if (_nombreController.text == null ||
        _nombreController.text == "" ||
        _precioController.text == '' ||
        _stockController.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error:'),
            content: Text(
                "Los siguientes campos son obligatorios:{nombre, precio, stock}"),
            actions: [
              TextButton(
                child: Text("Volver"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      final id = nanoid(10);
      Equipo equipo = Equipo(
          id: id,
          nombre: _nombreController.text ?? '',
          descripcion: _descripcionController.text ?? '',
          precio: precio,
          stock: stock,
          id_equipo_categoria: _id_equipo_categoria?.id ?? '',
          id_proveedor: _id_proveedor?.id ?? '');
      _createEquipo(context, equipo);
      final idfoto = nanoid(10);
      await _saveImageToLocalGallery(id);
      String urlImagen = await _uploadImage();
      print('url ${urlImagen}');
      EquipoFoto equipoFoto =
          EquipoFoto(id: idfoto, id_equipo: id, archivoUrl: urlImagen);
      print('equipo ${equipoFoto.archivoUrl}');
      _createEquipoFoto(context, equipoFoto);
      Navigator.of(context).pop();
    }
  }

  void _createEquipo(BuildContext context, Equipo equipo) async {
    await EquipoProvider().createEquipo(equipo);
  }

  void _createEquipoFoto(BuildContext context, EquipoFoto equipoFoto) async {
    await EquipoProvider().createEquipoFoto(equipoFoto);
  }
}
