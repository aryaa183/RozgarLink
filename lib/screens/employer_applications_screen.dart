import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerApplicationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('employerId', isEqualTo: user?.uid)
          .snapshots(), // ❌ removed orderBy
      builder: (context, snapshot) {
        // ✅ ERROR HANDLING
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final applications = snapshot.data!.docs;

        if (applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text("No applications yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                SizedBox(height: 8),
                Text("Workers will apply to your posted jobs",
                    style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          );
        }

        // ✅ LOCAL SORTING (instead of Firestore orderBy)
        applications.sort((a, b) {
          final aDate = (a['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final bDate = (b['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return bDate.compareTo(aDate);
        });

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final doc = applications[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 USER INFO
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          radius: 24,
                          child: Icon(Icons.person, color: Colors.orange),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['workerName'] ?? 'Worker',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['workerEmail'] ?? '',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(data['status'] ?? 'Applied'),
                      ],
                    ),

                    SizedBox(height: 12),
                    Divider(),

                    // 💼 JOB INFO
                    Row(
                      children: [
                        Icon(Icons.work, size: 16, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("Applied for: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            data['jobTitle'] ?? '',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // 📅 DATE
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text("Applied on: ${_formatDate(data['appliedAt'])}"),
                      ],
                    ),

                    // ✅ ACTION BUTTONS
                    if (data['status'] == 'Applied') ...[
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _updateStatus(context, doc.id, 'Accepted'),
                              icon: Icon(Icons.check, color: Colors.white),
                              label: Text("Accept",
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _updateStatus(context, doc.id, 'Rejected'),
                              icon: Icon(Icons.close, color: Colors.red),
                              label: Text("Reject",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ✅ STATUS BADGE
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  // ✅ DATE FORMAT
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

  // ✅ UPDATE STATUS
  Future<void> _updateStatus(
      BuildContext context, String docId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(docId)
          .update({'status': status});

      final doc = await FirebaseFirestore.instance
          .collection('applications')
          .doc(docId)
          .get();

      final data = doc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance.collection('notifications').add({
        'type': 'application_status',
        'title': status == 'Accepted'
            ? 'Application Accepted'
            : 'Application Rejected',
        'body': status == 'Accepted'
            ? 'Your application for ${data['jobTitle']} has been accepted!'
            : 'Your application for ${data['jobTitle']} has been rejected.',
        'workerId': data['workerId'],
        'jobId': data['jobId'],
        'createdAt': FieldValue.serverTimestamp(), // ✅ FIXED
        'read': false,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Application $status"),
            backgroundColor:
                status == 'Accepted' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}