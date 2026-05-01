import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobApplicationScreen extends StatefulWidget {
  final DocumentSnapshot jobData;

  JobApplicationScreen({required this.jobData});

  @override
  _JobApplicationScreenState createState() =>
      _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  String _status = "Not Applied";
  bool _isLoading = false;

  // ✅ APPLY FUNCTION (FULLY FIXED)
  void _applyJob() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please login first")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final job = widget.jobData;
      final jobId = job.id;
      final jobTitle = job['title'];

      // 🔍 CHECK IF ALREADY APPLIED (FIXED)
      final existing = await FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .where('workerId', isEqualTo: user.uid)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Already applied for this job"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // ✅ SAVE COMPLETE APPLICATION DATA (VERY IMPORTANT)
      await FirebaseFirestore.instance.collection('applications').add({
        'jobId': jobId,
        'jobTitle': jobTitle,
        'employerId': job['employerId'], // 🔥 REQUIRED for employer screen
        'workerId': user.uid,
        'workerName': user.displayName ?? 'Worker',
        'workerEmail': user.email ?? '',
        'status': 'Applied', // 🔥 MUST match everywhere
        'appliedAt': Timestamp.now(),
      });

      // ✅ UPDATE APPLICATION COUNT
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobId)
          .update({
        'applicationCount': FieldValue.increment(1),
      });

      setState(() {
        _status = "Applied";
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Application submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            // Job Title
            Text(
              job['title'] ?? '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // Wage
            Text(
              "₹${job['wage']} / day",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),

            SizedBox(height: 4),

            // Location
            Text(
              job['location'] ?? '',
              style: TextStyle(color: Colors.grey[700]),
            ),

            SizedBox(height: 20),

            // Status
            Text(
              "Status: $_status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _status == "Applied" ? Colors.green : Colors.grey,
              ),
            ),

            Spacer(),

            // Apply Button
            ElevatedButton(
              onPressed: _isLoading || _status == "Applied"
                  ? null
                  : _applyJob,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Apply Now"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}