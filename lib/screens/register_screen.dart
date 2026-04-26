import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'worker';

  void _register() async {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String password = _passCtrl.text.trim();

    if (name.isEmpty) {
      _showMessage("Please enter your name", isError: true);
      return;
    }
    if (email.isEmpty || !email.contains("@")) {
      _showMessage("Please enter a valid email", isError: true);
      return;
    }
    if (password.length < 6) {
      _showMessage("Password must be at least 6 characters", isError: true);
      return;
    }

    setState(() => _loading = true);
    String? error = await _auth.register(name, email, password, _selectedRole);
    setState(() => _loading = false);

    if (error == null) {
      _showMessage("Registration successful!", isError: false);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      _showMessage(error, isError: true);
    }
  }

  void _showMessage(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[400] : Colors.green[400],
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
            colors: [Colors.deepOrange[400]!, Colors.orange[700]!],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // ── TOP SECTION ──────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back,
                            color: Colors.white, size: 22),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Create Account",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("Join RozgarLink today",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.work_rounded, color: Colors.white, size: 36),
                  ],
                ),
              ),

              // ── FORM SECTION ─────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // NAME
                        _fieldLabel("Full Name"),
                        SizedBox(height: 8),
                        _buildTextField(
                          controller: _nameCtrl,
                          hint: "Enter your full name",
                          icon: Icons.person_outline,
                        ),

                        SizedBox(height: 16),

                        // EMAIL
                        _fieldLabel("Email"),
                        SizedBox(height: 8),
                        _buildTextField(
                          controller: _emailCtrl,
                          hint: "Enter your email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 16),

                        // PASSWORD
                        _fieldLabel("Password"),
                        SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Min. 6 characters",
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
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // ROLE SELECTOR
                        _fieldLabel("Register As"),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _selectedRole = 'worker'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'worker'
                                        ? Colors.orange
                                        : Colors.orange[50],
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.orange, width: 2),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.construction,
                                          color: _selectedRole == 'worker'
                                              ? Colors.white
                                              : Colors.orange,
                                          size: 28),
                                      SizedBox(height: 4),
                                      Text("Worker",
                                          style: TextStyle(
                                              color: _selectedRole == 'worker'
                                                  ? Colors.white
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _selectedRole = 'employer'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'employer'
                                        ? Colors.deepOrange
                                        : Colors.deepOrange[50],
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.deepOrange, width: 2),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.business,
                                          color: _selectedRole == 'employer'
                                              ? Colors.white
                                              : Colors.deepOrange,
                                          size: 28),
                                      SizedBox(height: 4),
                                      Text("Employer",
                                          style: TextStyle(
                                              color:
                                                  _selectedRole == 'employer'
                                                      ? Colors.white
                                                      : Colors.deepOrange,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 28),

                        // REGISTER BUTTON
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
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Colors.orange.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: Offset(0, 4))
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                  child: Text("Create Account",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1)),
                                ),
                              ),

                        SizedBox(height: 20),

                        // LOGIN LINK
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? ",
                                  style: TextStyle(color: Colors.grey[600])),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen())),
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
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

  Widget _fieldLabel(String label) {
    return Text(label,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 14));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.orange[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
      ),
    );
  }
}