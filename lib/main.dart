import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/admin/presentation/admin_shell.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/user/presentation/pages/scan_or_code_page.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    Widget homePage;

    if (authState.isLoading) {
      homePage = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (authState.error != null) {
      homePage = Scaffold(
        body: Center(child: Text('Erreur: ${authState.error}')),
      );
    } else if (authState.user != null && authState.role != null) {
      if (authState.role == 'admin') {
        homePage = const AdminShell();
      } else {
        homePage = const ScanOrCodePage();
      }
    } else {
      homePage = const AuthPage();
    }

    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: homePage,
    );
  }
}