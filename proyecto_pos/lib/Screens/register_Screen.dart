import "package:flutter/material.dart";
import "package:get/route_manager.dart";
import 'package:proyecto_pos/resp/user_repository.dart';
import 'package:proyecto_pos/models/user.dart';
import 'package:proyecto_pos/Screens/login_Screen.dart';
import '../widgets/text_formfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userName = TextEditingController();
  final userUsername = TextEditingController();
  final userPassword = TextEditingController();
  final userConfirmPassword = TextEditingController();
  UserRepository repository = UserRepository();
  bool isLoading = false;

  @override
  void dispose() {
    userName.dispose();
    userUsername.dispose();
    userPassword.dispose();
    userConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Usuario"),
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
            child: Container(
              width: 600,
              child: isLoading
                  ? Container(
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
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormfieldWidget(
                            hintText: "Nombre del Usuario",
                            controller: userName,
                            onChanged: (s) {},
                          ),
                          SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: "Username",
                            controller: userUsername,
                            onChanged: (s) {},
                          ),
                          SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: "Contraseña",
                            controller: userPassword,
                            isPassword: true,
                            onChanged: (s) {},
                          ),
                          SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: "Confirmar Contraseña",
                            controller: userConfirmPassword,
                            isPassword: true,
                            onChanged: (s) {},
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: _handleRegister,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Registrar",
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

  // FUNCION: Maneja el proceso de registro (adaptado desde _handleLogin)
  Future<void> _handleRegister() async {
    // Validación básica de campos vacíos
    if (userName.text.isEmpty ||
        userUsername.text.isEmpty ||
        userPassword.text.isEmpty) {
      Get.snackbar(
        "Error de Entrada",
        "Todos los campos son obligatorios.",
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    // Validar confirmación de contraseña
    if (userConfirmPassword.text.isEmpty) {
      Get.snackbar(
        "Error de Entrada",
        "Por favor confirme la contraseña.",
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    if (userPassword.text != userConfirmPassword.text) {
      Get.snackbar(
        "Error de Contraseña",
        "Las contraseñas no coinciden. Por favor verifique.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = User(
        name: userName.text,
        username: userUsername.text,
        password: userPassword.text,
      );

      // Llamada al repositorio para registrar
      final success = await repository.registerUser(user: user);

      // Evaluamos el resultado devuelto por el repositorio
      if (success) {
        Get.snackbar(
          "Registro Exitoso",
          "Usuario registrado. Redirigiendo al login...",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navegar a LoginScreen de forma segura
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(() => const LoginScreen());
        });
      } else {
        // El repositorio ya mostró un snackbar; solo detenemos la carga.
      }
      // Navegar a LoginScreen de forma segura
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => const LoginScreen());
      });
    } catch (e) {
      // Error de red o excepción
      Get.snackbar(
        "Error de Registro",
        "No se pudo registrar. Intenta más tarde.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      // Siempre detener la carga
      setState(() {
        isLoading = false;
      });
    }
  }
}
