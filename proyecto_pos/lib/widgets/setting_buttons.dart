import 'package:flutter/material.dart';

class SettingButtons extends StatelessWidget {
  const SettingButtons({
    super.key,
    required this.title,
    required this.selectedTitle,
    required this.onTap,
  });
  final String title;
  final String selectedTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(bottom: 10),
        color: selectedTitle == title ? Colors.deepOrange : Colors.white,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selectedTitle == title ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
