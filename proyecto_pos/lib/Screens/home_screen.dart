import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_pos/shared_preferences/user_data_manager.dart';
import 'package:proyecto_pos/models/user.dart';
import "dart:async";

import 'package:proyecto_pos/widgets/sidebar_child.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<User?>? future;
  String currentTime = "";
  int selectedPage = 0;
  void updateTime() {
    final now = DateTime.now();
    final formatedDate = DateFormat("yyyy-MM-dd").format(now);
    final formatedTime = DateFormat("HH:mm:ss").format(now);
    setState(() {
      currentTime = "$formatedTime - $formatedDate";
    });
  }

  @override
  void initState() {
    super.initState();
    future = UserDataManager.loadUserData();
    updateTime();
    Timer.periodic(Duration(seconds: 1), (timer) => updateTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Image.asset("assets/images/logo.jpeg"),
                title: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.name!,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentTime,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        SidebarChild(
                          onTap: () {
                            setState(() {
                              selectedPage = 0;
                            });
                          },
                          icon: Icons.home,
                          selectedItem: selectedPage,
                          index: 0,
                        ),

                        SidebarChild(
                          onTap: () {
                            setState(() {
                              selectedPage = 1;
                            });
                          },
                          icon: Icons.restaurant_menu,
                          selectedItem: selectedPage,
                          index: 1,
                        ),

                        SidebarChild(
                          onTap: () {
                            setState(() {
                              selectedPage = 2;
                            });
                          },
                          icon: Icons.receipt,
                          selectedItem: selectedPage,
                          index: 2,
                        ),

                        SidebarChild(
                          onTap: () {
                            setState(() {
                              selectedPage = 3;
                            });
                          },
                          icon: Icons.settings,
                          selectedItem: selectedPage,
                          index: 3,
                        ),

                        SidebarChild(
                          onTap: () {
                            setState(() {
                              selectedPage = 4;
                            });
                          },
                          icon: Icons.exit_to_app,
                          selectedItem: selectedPage,
                          index: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
