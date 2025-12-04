import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyecto_pos/widgets/setting_buttons.dart';
import 'package:proyecto_pos/widgets/setting_pages.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedPage = "Categorias";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: SettingPages(selectedPage: selectedPage),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                SettingButtons(
                  title: "Categorias",
                  selectedTitle: selectedPage,
                  onTap: () {
                    setState(() {
                      selectedPage = "Categorias";
                    });
                  },
                ),

                SettingButtons(
                  title: "Productos",
                  selectedTitle: selectedPage,
                  onTap: () {
                    setState(() {
                      selectedPage = "Productos";
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
