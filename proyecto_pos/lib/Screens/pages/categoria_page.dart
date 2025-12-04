import 'package:flutter/material.dart';
import 'package:proyecto_pos/Screens/pages/create_categoria_page.dart';
import 'package:proyecto_pos/bloc/category_bloc.dart';
import 'package:proyecto_pos/models/category.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  late CategoryBloc _categoryBloc;
  final int _currentUserId = 1;

  @override
  void initState() {
    super.initState();
    _categoryBloc = CategoryBloc();
    _categoryBloc.fetchCategories(_currentUserId);
  }

  @override
  void dispose() {
    _categoryBloc.dispose();
    super.dispose();
  }

  // Lógica de Eliminación (con confirmación)
  void _deleteCategory(int categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text(
            "¿Estás seguro de que deseas eliminar esta categoría?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _categoryBloc.deleteCategory(
                  categoryId: categoryId,
                  userId: _currentUserId,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Lógica de Edición (abre el diálogo precargado)
  void _editCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return CreateCategoriaPage(
          categoryBloc: _categoryBloc,
          currentUserId: _currentUserId,
          categoryToEdit: category,
        );
      },
    );
  }

  // Función auxiliar para construir las DataRows a partir de la lista de categorías
  List<DataRow> _buildRows(List<Category> categories) {
    return categories.map((category) {
      final categoryId = category.categoryid;
      final isActive = category.status == 1;

      return DataRow(
        cells: [
          DataCell(Text(categoryId?.toString() ?? 'N/A')),
          DataCell(Center(child: Text(category.categoryname ?? 'Sin Nombre'))),
          DataCell(
            Container(
              margin: EdgeInsets.all(8),
              width: 100,
              height: 50,
              color: isActive ? Colors.green : Colors.red,
              child: Center(
                child: Text(
                  isActive ? "Activo" : "Inactivo",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          DataCell(
            Row(
              children: [
                // BOTÓN DE EDICIÓN
                IconButton(
                  onPressed: () {
                    if (categoryId != null) {
                      _editCategory(category);
                    }
                  },
                  icon: Icon(Icons.edit, color: Colors.blue),
                ),
                SizedBox(width: 20),
                // BOTÓN DE ELIMINACIÓN
                IconButton(
                  onPressed: () {
                    if (categoryId != null) {
                      _deleteCategory(categoryId);
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⬅️ FILA DEL BOTÓN AÑADIR (Se asegura que ocupe su espacio)
          Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CreateCategoriaPage(
                        categoryBloc: _categoryBloc,
                        currentUserId: _currentUserId,
                      );
                    },
                  );
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Añadir Categoria", // ⬅️ El botón que debe aparecer
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // ⬅️ RESTO DE LA PÁGINA (LISTADO)
          Expanded(
            child: StreamBuilder<List<Category>>(
              stream: _categoryBloc.categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Agregado manejo de error para diagnóstico
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error al cargar categorías: ${snapshot.error}",
                    ),
                  );
                }

                final categories = snapshot.data ?? [];

                if (categories.isEmpty) {
                  return Center(child: Text("No hay categorías registradas."));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Id")),
                          DataColumn(label: Text("Categoria")),
                          DataColumn(label: Text("Estatus")),
                          DataColumn(label: Text("Acciones")),
                        ],
                        rows: _buildRows(categories),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
