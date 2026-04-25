import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';
import 'job_detail_screen.dart';
import 'learn_screen.dart';
import 'payment_screen.dart';
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

  final categories = ["All", "Construction", "Electrical", "Delivery"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // 🔥 DRAWER
      drawer: Drawer(
        child: ListView(
          children: [

            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.work, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text("RozgarLink",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Payments"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PaymentScreen()));
              },
            ),

            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()));
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("RozgarLink"),
        backgroundColor: Colors.orange,

        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
          ),

          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()));
            },
          ),
        ],
      ),

      body: _currentIndex == 0
          ? _buildJobsScreen()
          : _currentIndex == 1
              ? SavedJobsScreen()
              : _currentIndex == 2
                  ? AppliedJobsScreen()
                  : LearnScreen(),

      // 🔥 FIXED BOTTOM NAV (NO FADE ISSUE)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        // ✅ COLORS FIX
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black87, // 👈 NOT FADED NOW

        // ✅ KEEP LABELS ALWAYS VISIBLE
        showUnselectedLabels: true,

        // ✅ IMPORTANT (PREVENT FADE EFFECT)
        type: BottomNavigationBarType.fixed,

        onTap: (i) {
          setState(() => _currentIndex = i);
        },

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Saved"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "Applied"),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: "Learn"),
        ],
      ),
    );
  }

  // 🔥 JOB UI (UNCHANGED)
  Widget _buildJobsScreen() {
    return Column(
      children: [

        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search jobs...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (val) {
              setState(() => search = val.toLowerCase());
            },
          ),
        ),

        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: selectedCategory == cat,
                  selectedColor: Colors.orange,
                  onSelected: (_) {
                    setState(() => selectedCategory = cat);
                  },
                ),
              );
            },
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final jobs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = (data['title'] ?? "").toLowerCase();
                final category = data['category'] ?? "";

                return title.contains(search) &&
                    (selectedCategory == "All" ||
                        category == selectedCategory);
              }).toList();

              return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {

                  final job = jobs[index];
                  final data = job.data() as Map<String, dynamic>;

                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(data['title'] ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),

                        SizedBox(height: 5),

                        Text("₹${data['wage']} / day",
                            style: TextStyle(color: Colors.green)),

                        Text(data['location'] ?? ''),

                        SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          JobDetailScreen(jobData: job)));
                            },
                            child: Text("View"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}