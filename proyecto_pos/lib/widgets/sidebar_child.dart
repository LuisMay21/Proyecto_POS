import 'package:flutter/material.dart';

class SidebarChild extends StatelessWidget {
  const SidebarChild({
    super.key,
    required this.onTap,
    required this.icon,
    required this.selectedItem,
    required this.index,
  });
  final VoidCallback onTap;
  final IconData icon;
  final int selectedItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: selectedItem == index ? Colors.deepOrange : Colors.white,
        width: 56,
        child: Center(
          child: Icon(
            icon,
            size: 56,
            color: selectedItem == index ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
