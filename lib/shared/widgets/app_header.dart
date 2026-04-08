import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const AppHeader({
    super.key,
    required this.title,
    this.height = 120,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF80B8C5),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}