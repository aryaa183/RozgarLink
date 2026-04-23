import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';
import 'job_detail_screen.dart';
import 'learn_screen.dart';
import 'payment_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RozgarLink - Jobs"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen()));
            },
          ),
        ],
      ),

      // ── JOB LIST ──
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final jobs = snapshot.data!.docs;

          if (jobs.isEmpty) {
            return Center(child: Text("No jobs available"));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {

              final job = jobs[index];
              final data = job.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.work,
                      color: Colors.orange, size: 35),

                  title: Text(
                    data['title'] ?? 'No Title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    "₹${data['wage'] ?? 'N/A'} / day • ${data['location'] ?? 'Unknown'}",
                  ),

                  trailing: Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            JobDetailScreen(jobData: job),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Jobs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle), label: "Learn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: "Payments"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => LearnScreen()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => PaymentScreen()));
          }
        },
      ),
    );
  }
}