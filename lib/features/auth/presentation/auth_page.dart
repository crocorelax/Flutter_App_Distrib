import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() => isLogin = !isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLogin ? LoginPage(onSwitch: toggleAuthMode) : RegisterPage(onSwitch: toggleAuthMode),
    );
  }
}