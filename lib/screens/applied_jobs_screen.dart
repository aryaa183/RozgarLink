import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppliedJobsScreen extends StatelessWidget {

  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  // 🔥 CANCEL FUNCTION
  void cancelApplication(BuildContext context, String docId) async {
    await applications.doc(docId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Application Cancelled ❌"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: applications.snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final jobs = snapshot.data!.docs;

          if (jobs.isEmpty) {
            return Center(child: Text("No applications yet"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: jobs.length,
            itemBuilder: (context, index) {

              final doc = jobs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: Icon(Icons.assignment, color: Colors.orange),
                  ),

                  title: Text(data['title'] ?? ''),

                  subtitle: Text("Status: ${data['status']}"),

                  // 🔥 CANCEL BUTTON ADDED
                  trailing: TextButton(
                    onPressed: () {
                      cancelApplication(context, doc.id);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
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