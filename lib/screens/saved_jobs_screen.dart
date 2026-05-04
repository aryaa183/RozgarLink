import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  final CollectionReference savedJobs =
      FirebaseFirestore.instance.collection('saved_jobs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Jobs"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: savedJobs.snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No saved jobs"));
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {

              final jobDoc = jobs[index];
              final data = jobDoc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.bookmark, color: Colors.orange),
                  title: Text(data['title'] ?? 'No Title'),
                  subtitle: Text(
                    "₹${data['wage'] ?? 'N/A'} • ${data['location'] ?? 'Unknown'}",
                  ),

                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await jobDoc.reference.delete();
                    },
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailScreen(jobData: jobDoc),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}