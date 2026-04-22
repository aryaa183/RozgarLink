import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text("Profile Screen - Coming Soon",
          style: TextStyle(fontSize: 18)),
      ),
    );
  }
}