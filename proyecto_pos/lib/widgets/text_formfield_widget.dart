import 'package:flutter/material.dart';

class TextFormfieldWidget extends StatelessWidget {
  const TextFormfieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    required this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      obscureText: isPassword,
      onChanged: onChanged,
    );
  }
}
