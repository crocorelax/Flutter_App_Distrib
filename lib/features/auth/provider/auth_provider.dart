import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;
  final String? role;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.role,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? role,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      role: role ?? this.role,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi authApi;

  AuthNotifier(this.authApi) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await authApi.login(email, password);

      if (user == null) throw Exception("Utilisateur null");

      // récupérer rôle
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email) 
          .get();

      if (!doc.exists) throw Exception("Utilisateur non trouvé dans Firestore");

      final role = doc.data()?['role'] ?? 'user'; 

      state = state.copyWith(
        isLoading: false,
        user: user,
        role: role,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(
      String pseudo, String email, String password, String confirmPassword) async {

    if (password != confirmPassword) {
      state = state.copyWith(error: "Les mots de passe ne correspondent pas");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await authApi.register(pseudo, email, password);

      state = state.copyWith(
        isLoading: false,
        user: user,
        role: 'user', // par défaut
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await authApi.logout();
    state = AuthState(); // reset propre
  }
}

final authApiProvider = Provider<AuthApi>((ref) => AuthApi());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authApiProvider)),
);
