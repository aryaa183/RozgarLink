import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppliedJobsScreen extends StatefulWidget {
  @override
  _AppliedJobsScreenState createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  // 🔥 CANCEL FUNCTION
  void cancelApplication(BuildContext context, String docId, String? jobId) async {
    try {
      await applications.doc(docId).delete();

      // Update job count safely
      if (jobId != null && jobId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('jobs')
              .doc(jobId)
              .update({
            'applicationCount': FieldValue.increment(-1),
          });
        } catch (e) {}
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Application Cancelled ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error cancelling application"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text("Please login first"));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: applications
            .where('workerId', isEqualTo: user.uid)
            // ❌ REMOVED orderBy (fix for disappearing issue)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error.toString()}"));
          }

          final jobs = snapshot.data?.docs ?? [];

          // 🔥 Manual sorting (instead of orderBy)
          jobs.sort((a, b) {
            final aDate = (a['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            final bDate = (b['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            return bDate.compareTo(aDate);
          });

          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No applications yet",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final doc = jobs[index];
              final data = doc.data() as Map<String, dynamic>;

              final jobId = data['jobId'] ?? '';

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child:
                                Icon(Icons.assignment, color: Colors.orange),
                          ),
                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['jobTitle'] ?? 'Job',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),

                                // ✅ LOCATION
                                Text(
                                  data['location'] ?? 'No location',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),

                                // ✅ WAGE
                                Text(
                                  "₹${data['wage'] ?? '0'}/day",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                ),

                                // ✅ DATE
                                Text(
                                  "Applied on: ${_formatDate(data['appliedAt'])}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 11),
                                ),
                              ],
                            ),
                          ),

                          // ✅ STATUS BADGE
                          _buildStatusBadge(data['status'] ?? 'Applied'),
                        ],
                      ),

                      // ✅ CANCEL BUTTON
                      if ((data['status'] ?? 'Applied') == 'Applied') ...[
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              cancelApplication(context, doc.id, jobId);
                            },
                            child: Text("Cancel",
                                style: TextStyle(color: Colors.red)),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Accepted':
        color = Colors.green;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      if (date is Timestamp) {
        final d = date.toDate();
        return "${d.day}/${d.month}/${d.year}";
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}