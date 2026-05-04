import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'employer_post_job_screen.dart';
import 'employer_applications_screen.dart';

class EmployerHomeScreen extends StatefulWidget {
  @override
  _EmployerHomeScreenState createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: _currentIndex == 0
          ? _buildPostedJobsScreen()
          : _currentIndex == 1
              ? EmployerApplicationsScreen()
              : _buildManageJobsScreen(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EmployerPostJobScreen())),
              backgroundColor: Colors.orange,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Post Job",
                  style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  // APP BAR
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("RozgarLink Employer"),
      backgroundColor: Colors.orange,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => NotificationScreen())),
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => ProfileScreen())),
        ),
      ],
    );
  }

  // DRAWER
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            child: Text("Employer Panel",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          ListTile(
            title: Text("Jobs"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text("Applications"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 1);
            },
          ),
          ListTile(
            title: Text("Manage"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
        ],
      ),
    );
  }

  // NAVBAR
  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      selectedItemColor: Colors.orange,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Applications"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Manage"),
      ],
    );
  }

  // ================= JOB CARD UI =================
  Widget _jobCard(Map<String, dynamic> data) {
    final isExpired = _isJobExpired(data);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + STATUS
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['title'] ?? '',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? Colors.red[100]
                        : Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isExpired ? "Expired" : "Active",
                    style: TextStyle(
                        color: isExpired
                            ? Colors.red
                            : Colors.green,
                        fontSize: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // LOCATION
            Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 4),
                Text(data['location'] ?? ''),
              ],
            ),

            SizedBox(height: 4),

            // WAGE + CATEGORY
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16),
                SizedBox(width: 4),
                Text("${data['wage']}/day",
                    style: TextStyle(color: Colors.orange)),
                SizedBox(width: 12),
                Icon(Icons.category, size: 16),
                SizedBox(width: 4),
                Text(data['category'] ?? ''),
              ],
            ),

            SizedBox(height: 6),

            // DEADLINE
            if (data['endDate'] != null)
              Text("Deadline: ${_formatDate(data['endDate'])}"),

            SizedBox(height: 8),

            // FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Posted: ${_formatDate(data['createdAt'])}",
                    style: TextStyle(fontSize: 12)),
                Text(
                  "Applications: ${data['applicationCount'] ?? 0}",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= JOBS TAB =================
  Widget _buildPostedJobsScreen() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('employerId', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final jobs = snapshot.data!.docs;

        if (jobs.isEmpty) {
          return Center(child: Text("No jobs posted yet"));
        }

        jobs.sort((a, b) {
          final aDate = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final bDate = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return bDate.compareTo(aDate);
        });

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final data = jobs[index].data() as Map<String, dynamic>;
            return _jobCard(data);
          },
        );
      },
    );
  }

  // ================= MANAGE TAB =================
  Widget _buildManageJobsScreen() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('employerId', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final jobs = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final doc = jobs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Stack(
              children: [
                _jobCard(data),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  bool _isJobExpired(Map<String, dynamic> data) {
    try {
      final endDate = (data['endDate'] as Timestamp).toDate();
      return endDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date is Timestamp) {
        final d = date.toDate();
        return "${d.day}/${d.month}/${d.year}";
      }
    } catch (e) {}
    return '';
  }
}