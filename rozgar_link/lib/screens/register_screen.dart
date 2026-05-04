// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'home_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   String _role = 'worker';
//   final AuthService _auth = AuthService();
//   bool _loading = false;

//   void _register() async {
//     setState(() => _loading = true);
//     final user = await _auth.register(
//       _nameCtrl.text.trim(),
//       _emailCtrl.text.trim(),
//       _passCtrl.text.trim(),
//       _role,
//     );
//     setState(() => _loading = false);
//     if (user != null) {
//       Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (_) => HomeScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register"),
//         backgroundColor: Colors.orange),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameCtrl,
//               decoration: InputDecoration(
//                 labelText: "Full Name",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person)),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _emailCtrl,
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email)),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passCtrl,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock)),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Text("Register as: ",
//                   style: TextStyle(fontSize: 16)),
//                 Radio(value: 'worker', groupValue: _role,
//                   onChanged: (v) =>
//                     setState(() => _role = v.toString())),
//                 Text("Worker"),
//                 Radio(value: 'employer', groupValue: _role,
//                   onChanged: (v) =>
//                     setState(() => _role = v.toString())),
//                 Text("Employer"),
//               ],
//             ),
//             SizedBox(height: 24),
//             _loading
//               ? CircularProgressIndicator()
//               : ElevatedButton(
//                   onPressed: _register,
//                   child: Text("Register"),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                     backgroundColor: Colors.orange),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to capture user input
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  
  String _role = 'worker'; // Default role
  final AuthService _auth = AuthService();
  bool _loading = false;

  // The main registration function
  void _register() async {
    // 1. Basic Validation
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }
    
    if (_passCtrl.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    setState(() => _loading = true);

    // 2. Call the AuthService to handle Firebase Auth + Firestore
    final user = await _auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
      _role,
    );

    setState(() => _loading = false);

    // 3. Navigation or Error Handling
    if (user != null) {
      // If successful, go to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      // If failed, show an error message
      _showError("Registration failed. Email might already be in use.");
    }
  }

  // Helper function to show errors
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Full Name Field
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.orange),
              ),
            ),
            SizedBox(height: 16),

            // Email Field
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.orange),
              ),
            ),
            SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password (min 6 chars)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Colors.orange),
              ),
            ),
            SizedBox(height: 16),

            // Role Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Register as: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Radio(
                  value: 'worker',
                  groupValue: _role,
                  activeColor: Colors.orange,
                  onChanged: (v) => setState(() => _role = v.toString()),
                ),
                Text("Worker"),
                Radio(
                  value: 'employer',
                  groupValue: _role,
                  activeColor: Colors.orange,
                  onChanged: (v) => setState(() => _role = v.toString()),
                ),
                Text("Employer"),
              ],
            ),
            SizedBox(height: 24),

            // Register Button or Loading Spinner
            _loading
                ? CircularProgressIndicator(color: Colors.orange)
                : ElevatedButton(
                    onPressed: _register,
                    child: Text("Register Now", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
            
            // Login Link
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Already have an account? Login", style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}