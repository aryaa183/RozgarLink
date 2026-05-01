import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // REGISTER
  Future<String?> register(
      String name,
      String email,
      String password,
      String role,
      ) async {
    try {
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'profileImage': null,
        'createdAt': DateTime.now(),
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email already registered";
      } else if (e.code == 'invalid-email') {
        return "Invalid email format";
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      }
      return e.message;
    } catch (e) {
      return "Registration failed";
    }
  }

  // LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No account found with this email";
      } else if (e.code == 'wrong-password') {
        return "Incorrect password";
      } else if (e.code == 'invalid-email') {
        return "Invalid email format";
      }
      return e.message;
    } catch (e) {
      return "Login failed";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  // GET USER ROLE
  Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()?['role'];
    }
    return null;
  }

  // SAVE PROFILE PICTURE
  Future<String?> saveProfilePicture(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Upload to Firebase Storage
      final ref = _storage.ref().child('profile_pictures').child('${user.uid}.jpg');
      await ref.putFile(imageFile);
      
      // Get download URL
      final url = await ref.getDownloadURL();
      
      // Save URL to Firestore - use set with merge to handle both new and existing users
      await _db.collection('users').doc(user.uid).set({
        'profileImage': url,
      }, SetOptions(merge: true));
      
      return url;
    } catch (e) {
      return null;
    }
  }

  // SAVE PROFILE PICTURE FOR WEB
  Future<String?> saveProfilePictureWeb(List<int> imageBytes) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Upload to Firebase Storage
      final ref = _storage.ref().child('profile_pictures').child('${user.uid}.jpg');
      await ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      // Get download URL
      final url = await ref.getDownloadURL();
      
      // Save URL to Firestore - use set with merge to handle both new and existing users
      await _db.collection('users').doc(user.uid).set({
        'profileImage': url,
      }, SetOptions(merge: true));
      
      return url;
    } catch (e) {
      return null;
    }
  }

  // GET USER PROFILE IMAGE
  Future<String?> getProfileImage() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()?['profileImage'];
    }
    return null;
  }
}