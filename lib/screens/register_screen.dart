import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'worker';
  final AuthService _auth = AuthService();
  bool _loading = false;

  void _register() async {
    setState(() => _loading = true);
    final user = await _auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
      _role,
    );
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"),
        backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person)),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            Row(
              children: [
                Text("Register as: ",
                  style: TextStyle(fontSize: 16)),
                Radio(value: 'worker', groupValue: _role,
                  onChanged: (v) =>
                    setState(() => _role = v.toString())),
                Text("Worker"),
                Radio(value: 'employer', groupValue: _role,
                  onChanged: (v) =>
                    setState(() => _role = v.toString())),
                Text("Employer"),
              ],
            ),
            SizedBox(height: 24),
            _loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _register,
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.orange),
                ),
          ],
        ),
      ),
    );
  }
}