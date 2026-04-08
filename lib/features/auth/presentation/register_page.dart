import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

// import des widgets
import '../../../../shared/widgets/app_header.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final VoidCallback onSwitch;

  const RegisterPage({super.key, required this.onSwitch});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    pseudoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).register(
            pseudoController.text.trim(),
            emailController.text.trim(),
            passwordController.text.trim(),
            confirmController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(title: "Inscription"),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pseudo
                      TextFormField(
                        controller: pseudoController,
                        decoration: const InputDecoration(
                          labelText: "Pseudo",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Pseudo requis";
                          if (value.length < 3) return "Minimum 3 caractères";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Email requis";
                          if (!value.contains("@")) return "Email invalide";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Mot de passe
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Mot de passe requis";
                          if (value.length < 6) return "Minimum 6 caractères";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Confirmation mot de passe
                      TextFormField(
                        controller: confirmController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirmer mot de passe",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Confirmation requise";
                          if (value != passwordController.text) return "Les mots de passe ne correspondent pas";
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Affichage d'erreur
                      if (authState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // Bouton inscription
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          authState.isLoading ? "Chargement..." : "Inscription",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Lien pour basculer vers login
                      Center(
                        child: TextButton(
                          onPressed: widget.onSwitch,
                          child: const Text("Déjà un compte ? Se connecter"),
                        ),
                      ),
                    ],
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