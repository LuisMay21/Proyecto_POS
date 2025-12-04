import 'package:flutter/material.dart';
import 'package:proyecto_pos/Screens/pages/categoria_page.dart';
import 'package:proyecto_pos/Screens/pages/productos_page.dart';

class SettingPages extends StatelessWidget {
  const SettingPages({super.key, required this.selectedPage});
  final String selectedPage;
  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case "Categorias":
        return CategoriaPage();

      case "Productos":
        return ProductosPage();

      default:
        return CategoriaPage();
    }
  }
}
