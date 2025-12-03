import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:proyecto_pos/shared_preferences/user_data_manager.dart'; // Necesario para guardar la sesión
import 'package:proyecto_pos/Screens/home_screen.dart'; // Asume que esta pantalla existe
import 'package:proyecto_pos/resp/user_repository.dart';
import 'package:proyecto_pos/widgets/text_formfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userUsername = TextEditingController();
  final userPassword = TextEditingController();
  UserRepository repository = UserRepository();
  bool isLoading = false;

  // 💡 FUNCIÓN CORREGIDA: Usa async/await con try-catch-finally
  Future<void> _handleLogin() async {
    // Validación básica de campos vacíos
    if (userUsername.text.isEmpty || userPassword.text.isEmpty) {
      Get.snackbar(
        "Error de Entrada",
        "El usuario y la contraseña son obligatorios.",
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    // 1. Iniciar carga
    setState(() {
      isLoading = true;
    });

    try {
      // 2. Esperar la respuesta del servidor (la ejecución se PAUSA aquí)
      final user = await repository.loginUser(
        username: userUsername.text,
        password: userPassword.text,
      );

      // 3. Evaluación de Resultado
      if (user == null) {
        // A. Fallo de Credenciales (401 Unauthorized)
        Get.snackbar(
          "Error de Inicio",
          "Credenciales inválidas. Intente de nuevo.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // B. Login Exitoso (Servidor devolvió 200)

        // 4. Mostrar Snackbar de Éxito
        Get.snackbar(
          "Correcto",
          "¡Sesión iniciada con éxito! Redirigiendo a HOME.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 6. Navegación Segura: Usar Get.offAll() para ir a Home (HOME)
          // Se usa addPostFrameCallback para asegurar que la UI se haya actualizado completamente.
          Get.to(HomeScreen()); // Reemplaza con tu HomeScreen
        });
      }
    } catch (e) {
      // C. Fallo de Red o Excepción
      Get.snackbar(
        "Error de Red",
        "No se pudo conectar. Verifique el servidor o su Firewall.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      // 7. DETENER CARGA: Esto se ejecuta SIEMPRE.
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 💡 RESPONSIVIDAD: Determinar el ancho máximo (600px o 90% de la pantalla)
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login de Usuario"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/Background.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            // Aplicamos el ancho responsivo al contenedor principal
            child: Container(
              width: responsiveWidth,
              child: isLoading
                  ? Container(
                      // Contenedor de carga
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                        ),
                      ),
                    )
                  : Container(
                      // Contenedor de Formulario
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: "Username",
                            controller: userUsername,
                            onChanged: (s) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: "Contraseña",
                            controller: userPassword,
                            isPassword: true,
                            onChanged: (s) {},
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap:
                                _handleLogin, // Llamada a la función async/await
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Iniciar Sesión",
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
        ],
      ),
    );
  }
}
