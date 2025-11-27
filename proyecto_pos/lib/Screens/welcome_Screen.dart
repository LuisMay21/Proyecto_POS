import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:proyecto_pos/Screens/register_Screen.dart";
import 'package:proyecto_pos/Screens/login_Screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtener el ancho total de la pantalla una vez
    final screenWidth = MediaQuery.of(context).size.width;

    final responsiveWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(
                  0.9,
                ), // Hacerlo semi-transparente
                borderRadius: BorderRadius.circular(10),
              ),

              width: responsiveWidth,

              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
                bottom: 40,
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Text(
                    "Bienvenido a Pancho Tamales",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      // ... (estilos del botón)
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Botón Registrarse
                  InkWell(
                    onTap: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      // ... (estilos del botón)
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.deepOrange),
                      ),
                      child: const Center(
                        child: Text(
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepOrange,
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
        ],
      ),
    );
  }
}
