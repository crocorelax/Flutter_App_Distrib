import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion avec email et mot de passe
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Utilisateur non trouvé.');
        case 'wrong-password':
          throw Exception('Mot de passe incorrect.');
        case 'invalid-email':
          throw Exception('Email invalide.');
        default:
          throw Exception('Erreur login: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur login: $e');
    }
  }

  Future<User?> register(String pseudo, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(pseudo);

      // Ajouter dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'email': email,
        'role': 'user', // par défaut
      });

      return credential.user;
    } catch (e) {
      throw Exception('Erreur register: $e');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Récupérer l'utilisateur courant
  User? get currentUser => _auth.currentUser;
}
