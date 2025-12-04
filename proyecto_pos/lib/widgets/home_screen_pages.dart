import 'package:flutter/material.dart';
import 'package:proyecto_pos/Screens/dashboard_screen.dart';
import 'package:proyecto_pos/Screens/orders_screen.dart';
import 'package:proyecto_pos/Screens/settings_screen.dart';
import 'package:proyecto_pos/Screens/user_screen.dart';

class HomeScreenPages extends StatelessWidget {
  const HomeScreenPages({super.key, required this.selectedPage});
  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case 0:
        return DashboardScreen();
      case 1:
        return UserScreen();
      case 2:
        return OrdersScreen();
      case 3:
        return SettingsScreen();
      default:
        return DashboardScreen();
    }
  }
}
