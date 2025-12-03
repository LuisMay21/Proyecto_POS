import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:proyecto_pos/Screens/home_screen.dart";
import 'package:proyecto_pos/Screens/welcome_Screen.dart';
import 'package:proyecto_pos/shared_preferences/user_data_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogedin = false;
  Future<void> setDetails() async {
    isLogedin = await UserDataManager.hasUserData();
  }

  @override
  void initState() {
    super.initState();
    setDetails();
    Timer(Duration(seconds: 3), () {
      if (isLogedin) {
        Get.snackbar("Sesión", "Usuario ya logeado");
        Get.to(HomeScreen());
      } else {
        Get.to(() => WelcomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.jpeg', width: 150, height: 150),
      ),
    );
  }
}
