import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {

  final List<Map<String, String>> notifications = [
    {"title": "Job Applied", "desc": "You applied for Construction job"},
    {"title": "Payment Received", "desc": "₹600 credited"},
    {"title": "New Job Available", "desc": "Delivery job near you"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.orange,
      ),

      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {

          final n = notifications[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(Icons.notifications,
                    color: Colors.orange),
              ),
              title: Text(n['title']!),
              subtitle: Text(n['desc']!),
            ),
          );
        },
      ),
    );
  }
}