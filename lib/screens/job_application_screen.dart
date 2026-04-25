import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationScreen extends StatefulWidget {
  final DocumentSnapshot jobData;

  JobApplicationScreen({required this.jobData});

  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {

  String _status = "Not Applied";

  // ✅ APPLY FUNCTION (FIXED)
  void _applyJob() async {

  final jobTitle = widget.jobData['title'];

  // 🔍 CHECK IF ALREADY APPLIED
  final existing = await FirebaseFirestore.instance
      .collection('applications')
      .where('jobTitle', isEqualTo: jobTitle)
      .get();

  if (existing.docs.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Already applied for this job"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // ✅ SAVE APPLICATION
  await FirebaseFirestore.instance.collection('applications').add({
    'jobTitle': jobTitle,
    'status': 'Pending',
    'appliedAt': DateTime.now(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Application submitted successfully!"),
      backgroundColor: Colors.green,
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    final job = widget.jobData;

    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Job"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(job['title'],
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Text("₹${job['wage']} / day",
                style: TextStyle(color: Colors.green)),

            Text(job['location']),

            SizedBox(height: 20),

            Text("Status: $_status"),

            Spacer(),

            ElevatedButton(
              onPressed: _applyJob,
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