// category_repository.dart

import 'dart:convert';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryRepository {
  final String sqliteUrl = "192.168.1.6:3000";

  // ----------------------------------------------------------------------
  // 1. CREAR (POST): RUTA CORREGIDA a /categories
  // ----------------------------------------------------------------------
  Future<bool> createCategory({required Category category}) async {
    final response = await http.post(
      Uri.parse("http://$sqliteUrl/categories"),
      headers: {"content-type": "application/json"},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final String message = responsedata['message'];
      Get.snackbar("Creación de Categoría", message);
      return true;
    } else {
      try {
        final Map<String, dynamic> responsedata = jsonDecode(response.body);
        final String message =
            responsedata['message'] ??
            "Error desconocido al crear la categoría";
        Get.snackbar("Error", message);
      } catch (e) {
        Get.snackbar(
          "Error",
          "No se pudo conectar o procesar la solicitud. Código: ${response.statusCode}",
        );
      }
      return false;
    }
  }

  // ----------------------------------------------------------------------
  // 2. LISTAR (GET): RUTA CORREGIDA a /categories/:userId
  // ----------------------------------------------------------------------
  Future<List<Category>> getCategories({required int userId}) async {
    final response = await http.get(
      // ⬅️ Usa el ID como parámetro de ruta para coincidir con Express
      Uri.parse("http://$sqliteUrl/categories/$userId"),
      headers: {"content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final List<dynamic> categoryListJson = responsedata['categories'] ?? [];

      List<Category> categories = categoryListJson
          .map(
            (jsonItem) => Category.fromJson(jsonItem as Map<String, dynamic>),
          )
          .toList();

      return categories;
    } else {
      Get.snackbar(
        "Error de Listado",
        "Error al obtener categorías. Código: ${response.statusCode}",
      );
      return [];
    }
  }

  // ----------------------------------------------------------------------
  // 3. ACTUALIZAR (PUT): Usa el ID del objeto Category
  // ----------------------------------------------------------------------
  Future<bool> updateCategory({required Category category}) async {
    if (category.categoryid == null) {
      Get.snackbar(
        "Error",
        "El ID de la categoría es necesario para actualizar.",
      );
      return false;
    }

    final response = await http.put(
      // Usa categoryid en la URL
      Uri.parse("http://$sqliteUrl/categories/${category.categoryid}"),
      headers: {"content-type": "application/json"},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final String message = responsedata['message'];
      Get.snackbar("Actualización de Categoría", message);
      return true;
    } else {
      try {
        final Map<String, dynamic> responsedata = jsonDecode(response.body);
        final String message =
            responsedata['message'] ?? "Error al actualizar la categoría";
        Get.snackbar("Error", message);
      } catch (e) {
        Get.snackbar(
          "Error",
          "No se pudo actualizar la categoría. Código: ${response.statusCode}",
        );
      }
      return false;
    }
  }

  // ----------------------------------------------------------------------
  // 4. ELIMINAR (DELETE): Usa categoryId
  // ----------------------------------------------------------------------
  Future<bool> deleteCategory({required int categoryId}) async {
    final response = await http.delete(
      Uri.parse("http://$sqliteUrl/categories/$categoryId"),
      headers: {"content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final String message = responsedata['message'];
      Get.snackbar("Eliminación de Categoría", message);
      return true;
    } else {
      try {
        final Map<String, dynamic> responsedata = jsonDecode(response.body);
        final String message =
            responsedata['message'] ?? "Error al eliminar la categoría";
        Get.snackbar("Error", message);
      } catch (e) {
        Get.snackbar(
          "Error",
          "No se pudo eliminar la categoría. Código: ${response.statusCode}",
        );
      }
      return false;
    }
  }
}
