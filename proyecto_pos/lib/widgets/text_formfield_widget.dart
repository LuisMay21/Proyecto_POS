// text_formfield_widget.dart

import 'package:flutter/material.dart';

class TextFormfieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;

  // ⬅️ NUEVO: Parámetro para validación (requerido por Register/Login/Category)
  final String? Function(String? value)? validator;

  // ⬅️ NUEVO: Parámetro para ocultar texto
  final bool isPassword;

  const TextFormfieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validator, // Aceptar el validador
    this.isPassword = false, // Aceptar y establecer un valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Usar TextFormField para habilitar la validación
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        // Añade el borde que usas en el resto de tu UI para uniformidad
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (value) => onChanged?.call(value),
      validator: validator, // ⬅️ Pasar el validador
      // ⬅️ Pasar el valor de isPassword (obscureText)
      obscureText: isPassword,
    );
  }
}
