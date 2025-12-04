// create_categoria_page.dart

import 'package:flutter/material.dart';
import 'package:proyecto_pos/widgets/text_formfield_widget.dart';
import 'package:proyecto_pos/models/category.dart';
import 'package:proyecto_pos/bloc/category_bloc.dart';

class CreateCategoriaPage extends StatefulWidget {
  final CategoryBloc categoryBloc;
  final int currentUserId;
  final Category? categoryToEdit;

  const CreateCategoriaPage({
    super.key,
    required this.categoryBloc,
    required this.currentUserId,
    this.categoryToEdit,
  });

  @override
  State<CreateCategoriaPage> createState() => _CreateCategoriaPageState();
}

class _CreateCategoriaPageState extends State<CreateCategoriaPage> {
  final categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedStatus = 1;

  @override
  void initState() {
    super.initState();
    if (widget.categoryToEdit != null) {
      categoryController.text = widget.categoryToEdit!.categoryname ?? '';
      _selectedStatus = widget.categoryToEdit!.status ?? 1;
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryName = categoryController.text.trim();

    final categoryData = Category(
      categoryid: widget.categoryToEdit?.categoryid,
      categoryname: categoryName,
      status: _selectedStatus,
      userid: widget.currentUserId,
    );

    if (widget.categoryToEdit != null) {
      widget.categoryBloc.updateCategory(categoryData);
    } else {
      widget.categoryBloc.createCategory(categoryData);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.categoryToEdit != null
        ? "Editar Categoría"
        : "Añadir Categoría";
    final buttonText = widget.categoryToEdit != null ? "Actualizar" : "Añadir";

    return Dialog(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Campo de Texto
                TextFormfieldWidget(
                  hintText: "Nombre de la Categoría",
                  controller: categoryController,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre para la categoría';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // ⬅️ Dropdown de Estatus (Se asegura que esté dentro del Column)
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Activo')),
                    DropdownMenuItem(value: 0, child: Text('Inactivo')),
                  ],
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedStatus = newValue ?? 1;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Botón de Envío
                InkWell(
                  onTap: _handleSubmit,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
