import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot jobData;

  JobDetailScreen({required this.jobData});

  @override
  Widget build(BuildContext context) {
    final data = jobData.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title'] ?? 'Job Details'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Icon(Icons.work,
                  size: 80, color: Colors.orange),
            ),

            SizedBox(height: 20),

            Text(
              data['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            Text(
              "💰 Wage: ₹${data['wage'] ?? 'N/A'} / day",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "📍 Location: ${data['location'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "⏰ Shift: ${data['shift'] ?? 'Not specified'}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "🔧 Category: ${data['category'] ?? 'General'}",
              style: TextStyle(fontSize: 18),
            ),

            Spacer(),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Applied Successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Apply Now"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}