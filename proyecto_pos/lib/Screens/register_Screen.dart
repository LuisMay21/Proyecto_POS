import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
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
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {},
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
        ],
      ),
    );
  }
}
