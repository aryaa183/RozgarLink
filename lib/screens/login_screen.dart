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
  bool _obscurePassword = true;

  void _login() async {
    String email = _emailCtrl.text.trim();
    String password = _passCtrl.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      _showMessage("Please enter a valid email");
      return;
    }
    if (password.isEmpty) {
      _showMessage("Please enter password");
      return;
    }

    setState(() => _loading = true);
    String? error = await _auth.login(email, password);
    setState(() => _loading = false);

    if (error == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      _showMessage(error);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[700]!, Colors.deepOrange[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── TOP SECTION ──────────────────────────
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.work_rounded,
                            size: 60, color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text("RozgarLink",
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5)),
                      SizedBox(height: 6),
                      Text("Daily Work. Daily Wage.",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              letterSpacing: 1)),
                    ],
                  ),
                ),
              ),

              // ── BOTTOM FORM SECTION ──────────────────
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, -4))
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome Back!",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        SizedBox(height: 4),
                        Text("Login to find your daily work",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 14)),
                        SizedBox(height: 28),

                        // EMAIL
                        Text("Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Colors.orange),
                            filled: true,
                            fillColor: Colors.orange[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // PASSWORD
                        Text("Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Colors.orange),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.orange,
                              ),
                              onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2),
                            ),
                          ),
                        ),

                        SizedBox(height: 28),

                        // LOGIN BUTTON
                        _loading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.orange))
                            : Container(
                                width: double.infinity,
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange[700]!,
                                      Colors.deepOrange[400]!
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orange
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: Offset(0, 4))
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                  child: Text("Login",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1)),
                                ),
                              ),

                        SizedBox(height: 20),

                        // REGISTER LINK
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ",
                                  style:
                                      TextStyle(color: Colors.grey[600])),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            RegisterScreen())),
                                child: Text("Register",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}