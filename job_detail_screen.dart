import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot jobData;

  JobDetailScreen({required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobData['title']),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.work, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            Text(jobData['title'],
              style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("💰 Wage: ₹${jobData['wage']}/day",
              style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("📍 Location: ${jobData['location']}",
              style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("⏰ Shift: ${jobData['shift']}",
              style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("🔧 Category: ${jobData['category']}",
              style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Applied Successfully!")));
              },
              child: Text("Apply Now"),
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