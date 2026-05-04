import 'job_application_screen.dart';
import 'payment_screen.dart';         
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'job_detail_screen.dart';
import 'learn_screen.dart';

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
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen())),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final jobs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.work,
                    color: Colors.orange, size: 40),
                  title: Text(job['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "₹${job['wage']}/day • ${job['location']}"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  // onTap: () => Navigator.push(context,
                  //   MaterialPageRoute(
                  //     builder: (_) => JobDetailScreen(
                  //       jobData: job))),
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => JobApplicationScreen(jobData: job))), // NEW MEMBER 3 SCREEN
                ),
              );
            },
          );
        },
      ),
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
        // onTap: (index) {
        //   if (index == 1) Navigator.push(context,
        //     MaterialPageRoute(builder: (_) => LearnScreen()));
        // },
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LearnScreen()));
          } else if (index == 2) {
          // This opens your new Member 3 Payment Screen!
              Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
            }
        },
      ),
    );
  }
}