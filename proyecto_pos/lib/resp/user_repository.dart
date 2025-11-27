import 'dart:convert';
import "package:get/get.dart";
import 'package:proyecto_pos/shared_preferences/user_data_manager.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

// Define la clase que contiene la lógica para hablar con el servidor.
class UserRepository {
  // La dirección base del servidor backend.
  final String sqliteUrl = "192.168.1.6:3000";
  // ----------------------------------------------------------------------
  // Función para REGISTRAR un nuevo usuario
  // ----------------------------------------------------------------------
  // 'Future<void>' indica que la función no devolverá datos (solo completa una acción).

  Future<void> registerUser({required User user}) async {
    // 1. Envía la petición HTTP (POST) al servidor
    final response = await http.post(
      // CONEXIÓN: Ruta de la API (DEBE SER: "$sqliteUrl/users/register" para coincidir con tu Express)
      Uri.parse("http://$sqliteUrl/users/register"),
      // Indica que el contenido enviado es JSON
      headers: {"content-type": "application/json"},

      // Cuerpo: Convierte los datos del objeto 'user' en formato JSON
      body: jsonEncode({
        "name": user.name,
        "username": user.username,
        "password": user.password,
      }),
    );

    // 2. Manejo de la Respuesta del Servidor
    // Éxito: Código 200/201 (Debería ser 201 Created para registro exitoso)
    if (response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final String message = responsedata['message'];
      // Muestra una notificación de éxito
      Get.snackbar("Registro ", message);

      // Error Interno del Servidor (500)
    } else if (response.statusCode == 500) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      final String message = responsedata['message'];
      // Muestra una notificación de error interno
      Get.snackbar("Registro", message);

      // Otros Errores (400 Bad Request, 409 Conflict, etc.)
    } else {
      // Muestra una notificación de error genérico
      Get.snackbar("Registro", "Error al registrar usuario");
    }
  }

  // ----------------------------------------------------------------------
  // Función para INICIAR SESIÓN
  // ----------------------------------------------------------------------
  // 'Future<User?>' indica que la función devolverá un objeto User o 'null'.
  Future<User?> loginUser({
    required String username,
    required String password,
  }) async {
    // 1. Envía la petición HTTP (POST) al servidor
    final response = await http.post(
      // CONEXIÓN: Ruta de la API (DEBE SER: "$sqliteUrl/users/login")
      Uri.parse("http://$sqliteUrl/users/login"),
      headers: {"content-type": "application/json"},
      // Cuerpo: Envía el nombre de usuario y la contraseña en JSON
      body: jsonEncode({"username": username, "password": password}),
    );

    // 2. Manejo de la Respuesta del Servidor

    // Éxito: Código 200 OK
    if (response.statusCode == 200) {
      final Map<String, dynamic> responsedata = jsonDecode(response.body);
      // Convierte los datos del usuario recibidos a un objeto Dart (User.fromJson)
      final user = User.fromJson(responsedata['user']);
      await UserDataManager.saveUserData(user);

      // Devuelve el objeto User
      return user;

      // Fallo de Credenciales: Código 401 Unauthorized
    } else if (response.statusCode == 401) {
      // Devuelve 'null' para indicar que la autenticación falló
      return null;

      // Otros Errores (ej. 500 Internal Server Error)
    } else {
      Get.snackbar("Login", "Error al iniciar sesión");
      // Lanza una excepción para detener la ejecución y manejar el fallo
      throw Exception("Error al iniciar sesión");
    }
  }
}
