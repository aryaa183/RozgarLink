import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Applications"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data!.docs;

          if (apps.isEmpty) {
            return Center(child: Text("No applications yet"));
          }

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {

              final data = apps[index].data()
                  as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.work, color: Colors.orange),
                  title: Text(data['title'] ?? ''),
                  subtitle: Text(
                    "₹${data['wage']} • ${data['location']}",
                  ),
                  trailing: Text(
                    data['status'] ?? '',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}