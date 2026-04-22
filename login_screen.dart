import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    final user = await _auth.login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed. Check credentials.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 80, color: Colors.orange),
            Text("RozgarLink", style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold,
              color: Colors.orange)),
            SizedBox(height: 40),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock)),
            ),
            SizedBox(height: 24),
            _loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.orange),
                ),
            TextButton(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => RegisterScreen())),
              child: Text("Don't have account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}