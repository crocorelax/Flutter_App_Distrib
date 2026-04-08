import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

// import des widgets
import '../../../../shared/widgets/app_header.dart';


class LoginPage extends ConsumerStatefulWidget {
  final VoidCallback onSwitch;

  const LoginPage({super.key, required this.onSwitch});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  @override
Widget build(BuildContext context) {
  // 🔹 Écoute les changements du provider
  ref.listen(authProvider, (previous, next) {
    if (next.user != null && next.role != null) {
      // Redirige selon le rôle
      if (next.role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home'); // page scan
      }
    }
  });

  final authState = ref.watch(authProvider);

  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        const AppHeader(title: "Connexion"),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 30),
                      if (authState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          authState.isLoading ? "Chargement..." : "Connexion",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}