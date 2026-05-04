// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';
// import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/employer_home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RozgarLink',
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: AuthCheck(),
//     );
//   }
// }

// class AuthCheck extends StatefulWidget {
//   @override
//   _AuthCheckState createState() => _AuthCheckState();
// }

// class _AuthCheckState extends State<AuthCheck> {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(
//               backgroundColor: Colors.grey[100],
//               body: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.work, size: 80, color: Colors.orange),
//                     SizedBox(height: 20),
//                     CircularProgressIndicator(color: Colors.orange),
//                     SizedBox(height: 10),
//                     Text("Loading...", style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             );
//           }

//           if (snapshot.hasData && snapshot.data!.exists) {
//             final role = snapshot.data!.get('role');
//             if (role == 'employer') {
//               return EmployerHomeScreen();
//             }
//           }
//           return HomeScreen();
//         },
//       );
//     } else {
//       return LoginScreen();
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/employer_home_screen.dart';

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
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("Logged in UID: ${user.uid}"); // 🔥 helpful for reviews

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work, size: 80, color: Colors.orange),
                    SizedBox(height: 20),
                    CircularProgressIndicator(color: Colors.orange),
                    SizedBox(height: 10),
                    Text("Loading...",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          /// ❌ HANDLE ERROR
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }

          /// ✅ SAFE DATA ACCESS
          if (snapshot.hasData && snapshot.data!.exists) {
            final data =
                snapshot.data!.data() as Map<String, dynamic>;
            final role = data['role'] ?? 'worker';

            if (role == 'employer') {
              return EmployerHomeScreen();
            }
          }

          return HomeScreen();
        },
      );
    } else {
      return LoginScreen();
    }
  }
}