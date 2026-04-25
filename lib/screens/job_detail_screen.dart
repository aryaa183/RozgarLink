import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot jobData;

  JobDetailScreen({required this.jobData});

  @override
  Widget build(BuildContext context) {
    final data = jobData.data() as Map<String, dynamic>;
    final String jobId = jobData.id;

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
              child: Icon(Icons.work, size: 80, color: Colors.orange),
            ),

            SizedBox(height: 20),

            Text(
              data['title'] ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            Text("💰 Wage: ₹${data['wage'] ?? 'N/A'} / day",
                style: TextStyle(fontSize: 18)),

            Text("📍 Location: ${data['location'] ?? 'Unknown'}",
                style: TextStyle(fontSize: 18)),

            Text("🔧 Category: ${data['category'] ?? 'General'}",
                style: TextStyle(fontSize: 18)),

            Spacer(),

            // ❤️ SAVE BUTTON
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('saved_jobs')
                    .add(data);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved ❤️")),
                );
              },
              icon: Icon(Icons.bookmark),
              label: Text("Save Job"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 10),

            // 📊 APPLY BUTTON (FIXED)
            ElevatedButton(
              onPressed: () async {

                final ref = FirebaseFirestore.instance
                    .collection('applications');

                // 🔍 CHECK ALREADY APPLIED
                final existing = await ref
                    .where('jobId', isEqualTo: jobId)
                    .get();

                if (existing.docs.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Already Applied ❗"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // ✅ ADD NEW APPLICATION
                await ref.add({
                  'jobId': jobId,
                  'title': data['title'],
                  'status': 'Applied',
                  'date': DateTime.now(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Applied Successfully ✅"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Apply Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}