import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RozgarLink',
      theme: ThemeData(primarySwatch: Colors.orange),

      // 🔥 AUTO LOGIN CHECK
      home: AuthCheck(),
    );
  }
}

// 🔐 CHECK LOGIN STATUS
class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // ✅ Already logged in
      return HomeScreen();
    } else {
      // ❌ Not logged in
      return LoginScreen();
    }
  }
}