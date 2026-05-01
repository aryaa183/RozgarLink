import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => _clearAllNotifications(context),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs
              .where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                // Show notifications for current user
                return data['workerId'] == user?.uid ||
                       data['employerId'] == user?.uid ||
                       data['type'] == 'new_job';
              })
              .toList();

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text("No notifications yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  SizedBox(height: 8),
                  Text("You'll see updates about jobs and applications",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;

              return _buildNotificationTile(context, doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, String docId, Map<String, dynamic> data) {
    IconData icon;
    Color color;

    switch (data['type']) {
      case 'new_job':
        icon = Icons.work;
        color = Colors.blue;
        break;
      case 'application_status':
        icon = data['title'] == 'Application Accepted' 
            ? Icons.check_circle 
            : Icons.cancel;
        color = data['title'] == 'Application Accepted' 
            ? Colors.green 
            : Colors.red;
        break;
      case 'new_application':
        icon = Icons.person_add;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.orange;
    }

    return Dismissible(
      key: Key(docId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          title: Text(
            data['title'] ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(data['body'] ?? ''),
          trailing: Text(
            _formatDate(data['createdAt']),
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      if (date is Timestamp) {
        final d = date.toDate();
        final now = DateTime.now();
        final diff = now.difference(d);
        
        if (diff.inMinutes < 1) return 'Just now';
        if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
        if (diff.inHours < 24) return '${diff.inHours}h ago';
        if (diff.inDays < 7) return '${diff.inDays}d ago';
        
        return "${d.day}/${d.month}/${d.year}";
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  void _clearAllNotifications(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Clear All Notifications"),
        content: Text("Are you sure you want to clear all notifications?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final user = FirebaseAuth.instance.currentUser;
      final notifications = await FirebaseFirestore.instance
          .collection('notifications')
          .get();
      
      for (final doc in notifications.docs) {
        final data = doc.data();
        if (data['workerId'] == user?.uid || 
            data['employerId'] == user?.uid ||
            data['type'] == 'new_job') {
          await doc.reference.delete();
        }
      }
    }
  }
}