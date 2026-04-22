import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register
  Future<User?> register(String name, String email,
      String password, String role) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      // Save to Firestore
      await _db.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'createdAt': DateTime.now(),
      });
      return result.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );
      return result.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async => await _auth.signOut();

  // Current User
  User? get currentUser => _auth.currentUser;
}