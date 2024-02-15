import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  // Constructor que requiere un controlador y permite personalizar otros parámetros
  CustomTextField({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 13.0),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        ),
        textCapitalization: TextCapitalization.characters,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}

class CustomTextFieldDecorated extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  // Constructor que requiere un controlador y permite personalizar otros parámetros
  CustomTextFieldDecorated({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null, // Añade esta línea
      ),
    );
  }
}
