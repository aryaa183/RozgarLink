import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'job_detail_screen.dart';
import 'learn_screen.dart';
import 'saved_jobs_screen.dart';
import 'applied_jobs_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String search = "";
  String selectedCategory = "All";

  final categories = ["All", "Construction", "Electrical", "Delivery", "Plumbing"];

  // ── HARDCODED JOBS DATA ──────────────────────────────────
  final List<Map<String, dynamic>> allJobs = [
    {
      'title': 'Construction Worker',
      'wage': '600',
      'location': 'Andheri, Mumbai',
      'category': 'Construction',
      'shift': '7AM - 2PM',
      'employer': 'Sharma Builders',
    },
    {
      'title': 'Electrician Helper',
      'wage': '500',
      'location': 'Pune, Maharashtra',
      'category': 'Electrical',
      'shift': '9AM - 5PM',
      'employer': 'PowerFix Co.',
    },
    {
      'title': 'Delivery Boy',
      'wage': '450',
      'location': 'Nashik, Maharashtra',
      'category': 'Delivery',
      'shift': '10AM - 6PM',
      'employer': 'QuickDeliver',
    },
    {
      'title': 'Plumber Assistant',
      'wage': '480',
      'location': 'Thane, Mumbai',
      'category': 'Plumbing',
      'shift': '8AM - 4PM',
      'employer': 'PipeKing Services',
    },
    {
      'title': 'Site Supervisor',
      'wage': '800',
      'location': 'Bandra, Mumbai',
      'category': 'Construction',
      'shift': '8AM - 5PM',
      'employer': 'BuildRight Ltd.',
    },
    {
      'title': 'Electrician',
      'wage': '650',
      'location': 'Nagpur, Maharashtra',
      'category': 'Electrical',
      'shift': '9AM - 6PM',
      'employer': 'VoltCare',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: _currentIndex == 0
          ? _buildJobsScreen()
          : _currentIndex == 1
              ? SavedJobsScreen()
              : _currentIndex == 2
                  ? AppliedJobsScreen()
                  : LearnScreen(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── APP BAR ──────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.work, color: Colors.white, size: 22),
          SizedBox(width: 8),
          Text("RozgarLink",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: Colors.orange,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => NotificationScreen())),
        ),
        IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ProfileScreen())),
        ),
      ],
    );
  }

  // ── DRAWER ───────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.orange, size: 32),
                ),
                SizedBox(height: 10),
                Text("Welcome, Worker!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text("Find your daily work here",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.orange),
            title: Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.orange),
            title: Text("Profile"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text("Notifications"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => NotificationScreen())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ───────────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (i) => setState(() => _currentIndex = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Applied"),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: "Learn"),
      ],
    );
  }

  // ── JOBS SCREEN ──────────────────────────────────────────
  Widget _buildJobsScreen() {
    // Filter jobs
    final filtered = allJobs.where((job) {
      final title = job['title'].toLowerCase();
      final category = job['category'];
      return title.contains(search) &&
          (selectedCategory == "All" || category == selectedCategory);
    }).toList();

    return Column(
      children: [
        // Header Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Find Daily Work",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("${allJobs.length} jobs available near you",
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              SizedBox(height: 12),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search jobs...",
                    prefixIcon: Icon(Icons.search, color: Colors.orange),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (val) =>
                      setState(() => search = val.toLowerCase()),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        // Category Chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final isSelected = selectedCategory == cat;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey[300]!),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 6)
                            ]
                          : [],
                    ),
                    child: Text(cat,
                        style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 8),

        // Jobs Count
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text("${filtered.length} jobs found",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),

        // Job Cards
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No jobs found",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final job = filtered[index];
                    return _buildJobCard(job, context);
                  },
                ),
        ),
      ],
    );
  }

  // ── JOB CARD ─────────────────────────────────────────────
  Widget _buildJobCard(Map<String, dynamic> job, BuildContext context) {
    final categoryColors = {
      'Construction': Colors.brown,
      'Electrical': Colors.yellow[800],
      'Delivery': Colors.blue,
      'Plumbing': Colors.teal,
    };
    final color = categoryColors[job['category']] ?? Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.work, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title'],
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      SizedBox(height: 2),
                      Text(job['employer'],
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                // Wage Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text("₹${job['wage']}/day",
                      style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Info Row
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(job['location'],
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 12)),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(job['shift'],
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            SizedBox(height: 12),
            // Category + Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(job['category'],
                      style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                JobDetailScreen(jobData: job)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Text("View Job",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}