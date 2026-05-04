import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text("Learn Screen - Coming Soon",
          style: TextStyle(fontSize: 18)),
      ),
    );
  }
}