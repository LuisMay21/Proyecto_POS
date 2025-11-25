import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";

import "../models/user.dart";

// Esta clase maneja la sesión del usuario (guardar y cargar) en el almacenamiento local.
class UserDataManager {
  // Función estática para cargar los datos del usuario. Devuelve un objeto User o null si no hay sesión.
  static Future<User?> loadUserData() async {
    // 1. Espera a obtener la instancia de SharedPreferences (el almacenamiento local).
    final prefs = await SharedPreferences.getInstance();
    // 2. Intenta obtener la cadena de texto JSON guardada bajo la clave 'userJson'.
    final userJson = prefs.getString('userJson');

    // 3. Verifica si se encontró alguna cadena de texto (si la sesión está activa).
    if (userJson != null) {
      // 4. Usa jsonDecode para convertir la cadena JSON de vuelta a un mapa de datos (Map<String, dynamic>).
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      // 5. Crea un objeto User real usando el constructor factory fromJson de tu modelo.
      final User user = User.fromJson(userMap);
      // 6. Devuelve el objeto User cargado.
      return user;
    } else {
      // 7. Si no había datos, devuelve null (no hay sesión).
      return null;
    }
  }

  // Función estática para guardar un objeto User en la memoria.
  static Future<void> saveUserData(User user) async {
    // 1. Obtiene la instancia de SharedPreferences.
    final prefs = await SharedPreferences.getInstance();

    // 2. Guarda la cadena de texto JSON:
    //    a. user.toJson(): Convierte el objeto User a un mapa de datos.
    //    b. jsonEncode(): Convierte ese mapa de datos a una cadena de texto JSON.
    //    c. setString: Guarda la cadena de texto JSON con la clave 'userJson'.
    await prefs.setString('userJson', jsonEncode(user.toJson()));
  }

  // Función estática para verificar rápidamente si existe una sesión guardada.
  static Future<bool> hasUserData() async {
    // 1. Obtiene la instancia de SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    // 2. Devuelve true si la clave 'userJson' existe, o false si no existe.
    return prefs.containsKey('userJson');
  }

  // Función estática para borrar la sesión guardada (cerrar sesión).
  static Future<void> clearUserData() async {
    // 1. Obtiene la instancia de SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    // 2. Elimina la clave 'userJson' y su valor asociado.
    await prefs.remove('userJson');
  }
}
