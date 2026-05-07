// import '../services/location_service.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'profile_screen.dart';
// import 'job_detail_screen.dart';
// import 'learn_screen.dart';
// import 'saved_jobs_screen.dart';
// import 'applied_jobs_screen.dart';
// import 'notification_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;
//   String search = "";
//   String selectedCategory = "All";
//   double? userLat;
//   double? userLng;

//   final categories = ["All", "Construction", "Electrical", "Delivery", "Plumbing", "Painting", "Carpenter", "Welder", "Other"];

//   // ── HARDCODED JOBS DATA (Fallback) ──────────────────────────────────
//   final List<Map<String, dynamic>> allJobs = [
//     {
//       'title': 'Construction Worker',
//       'wage': '600',
//       'location': 'Andheri, Mumbai',
//       'category': 'Construction',
//       'shift': '7AM - 2PM',
//       'employer': 'Sharma Builders',
//     },
//     {
//       'title': 'Electrician Helper',
//       'wage': '500',
//       'location': 'Pune, Maharashtra',
//       'category': 'Electrical',
//       'shift': '9AM - 5PM',
//       'employer': 'PowerFix Co.',
//     },
//     {
//       'title': 'Delivery Boy',
//       'wage': '450',
//       'location': 'Nashik, Maharashtra',
//       'category': 'Delivery',
//       'shift': '10AM - 6PM',
//       'employer': 'QuickDeliver',
//     },
//     {
//       'title': 'Plumber Assistant',
//       'wage': '480',
//       'location': 'Thane, Mumbai',
//       'category': 'Plumbing',
//       'shift': '8AM - 4PM',
//       'employer': 'PipeKing Services',
//     },
//     {
//       'title': 'Site Supervisor',
//       'wage': '800',
//       'location': 'Bandra, Mumbai',
//       'category': 'Construction',
//       'shift': '8AM - 5PM',
//       'employer': 'BuildRight Ltd.',
//     },
//     {
//       'title': 'Electrician',
//       'wage': '650',
//       'location': 'Nagpur, Maharashtra',
//       'category': 'Electrical',
//       'shift': '9AM - 6PM',
//       'employer': 'VoltCare',
//     },
//   ];

//   // Check if job is expired
//   bool _isJobExpired(Map<String, dynamic> data) {
//     if (data['endDate'] == null) return false;
//     try {
//       final endDate = (data['endDate'] as Timestamp).toDate();
//       return endDate.isBefore(DateTime.now());
//     } catch (e) {
//       return false;
//     }
//   }

//   // Format date for display
//   String _formatDate(dynamic date) {
//     if (date == null) return '';
//     try {
//       if (date is Timestamp) {
//         return "${date.toDate().day}/${date.toDate().month}/${date.toDate().year}";
//       } else if (date is DateTime) {
//         return "${date.day}/${date.month}/${date.year}";
//       }
//       return '';
//     } catch (e) {
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       drawer: _buildDrawer(context),
//       appBar: _buildAppBar(context),
//       body: _currentIndex == 0
//           ? _buildJobsScreen()
//           : _currentIndex == 1
//               ? SavedJobsScreen()
//               : _currentIndex == 2
//                   ? AppliedJobsScreen()
//                   : LearnScreen(),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   @override
// void initState() {
//   super.initState();
//   _loadUserLocation();
// }
  
//   // ── APP BAR ──────────────────────────────────────────────
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       title: Row(
//         children: [
//           Icon(Icons.work, color: Colors.white, size: 22),
//           SizedBox(width: 8),
//           Text("RozgarLink",
//               style: TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//         ],
//       ),
//       backgroundColor: Colors.orange,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.notifications, color: Colors.white),
//           onPressed: () => Navigator.push(context,
//               MaterialPageRoute(builder: (_) => NotificationScreen())),
//         ),
//         IconButton(
//           icon: Icon(Icons.person, color: Colors.white),
//           onPressed: () => Navigator.push(context,
//               MaterialPageRoute(builder: (_) => ProfileScreen())),
//         ),
//       ],
//     );
//   }

//   double? _getDistance(Map<String, dynamic> job) {
//   if (userLat == null || userLng == null) return null;
//   if (job['lat'] == null || job['lng'] == null) return null;

//   return LocationService.calculateDistance(
//     userLat!,
//     userLng!,
//     job['lat'],
//     job['lng'],
//   );
// }
   
//   // ── DRAWER ───────────────────────────────────────────────
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.orange),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, color: Colors.orange, size: 32),
//                 ),
//                 SizedBox(height: 10),
//                 Text("Welcome, Worker!",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold)),
//                 Text("Find your daily work here",
//                     style: TextStyle(color: Colors.white70, fontSize: 12)),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.home, color: Colors.orange),
//             title: Text("Home"),
//             onTap: () => Navigator.pop(context),
//           ),
//           ListTile(
//             leading: Icon(Icons.person, color: Colors.orange),
//             title: Text("Profile"),
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => ProfileScreen())),
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications, color: Colors.orange),
//             title: Text("Notifications"),
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => NotificationScreen())),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.logout, color: Colors.red),
//             title: Text("Logout", style: TextStyle(color: Colors.red)),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   // ── BOTTOM NAV ───────────────────────────────────────────
//   Widget _buildBottomNav() {
//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       selectedItemColor: Colors.orange,
//       unselectedItemColor: Colors.grey,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
//       onTap: (i) => setState(() => _currentIndex = i),
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
//         BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
//         BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Applied"),
//         BottomNavigationBarItem(icon: Icon(Icons.school), label: "Learn"),
//       ],
//     );
//   }

//   Future<void> _loadUserLocation() async {
//   final pos = await LocationService.getUserLocation();

//   if (pos != null) {
//     userLat = pos.latitude;
//     userLng = pos.longitude;
//   }

//   setState(() {});
// }

//   // ── JOBS SCREEN ──────────────────────────────────────────
//   Widget _buildJobsScreen() {
//     return Column(
//       children: [
//         // Header Banner
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
//           decoration: BoxDecoration(
//             color: Colors.orange,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Find Daily Work",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold)),
//               SizedBox(height: 4),
//               Text("Jobs posted by employers",
//                   style: TextStyle(color: Colors.white70, fontSize: 13)),
//               SizedBox(height: 12),
//               // Search Bar
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search jobs...",
//                     prefixIcon: Icon(Icons.search, color: Colors.orange),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onChanged: (val) =>
//                       setState(() => search = val.toLowerCase()),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         SizedBox(height: 12),

//         // Category Chips
//         SizedBox(
//           height: 40,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             itemCount: categories.length,
//             itemBuilder: (_, i) {
//               final cat = categories[i];
//               final isSelected = selectedCategory == cat;
//               return Padding(
//                 padding: EdgeInsets.only(right: 8),
//                 child: GestureDetector(
//                   onTap: () => setState(() => selectedCategory = cat),
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.orange : Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: isSelected
//                               ? Colors.orange
//                               : Colors.grey[300]!),
//                       boxShadow: isSelected
//                           ? [
//                               BoxShadow(
//                                   color: Colors.orange.withOpacity(0.3),
//                                   blurRadius: 6)
//                             ]
//                           : [],
//                     ),
//                     child: Text(cat,
//                         style: TextStyle(
//                             color:
//                                 isSelected ? Colors.white : Colors.grey[700],
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13)),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),

//         SizedBox(height: 8),

//         // Jobs from Firestore
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('jobs')
//                 .orderBy('createdAt', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               final allFirestoreJobs = snapshot.data!.docs
//                   .map((doc) => {
//                         ...doc.data() as Map<String, dynamic>,
//                         'id': doc.id,
//                       })
//                   .toList();

//               // Filter jobs
//               final filtered = allFirestoreJobs.where((job) {
//                 final title = (job['title'] ?? '').toString().toLowerCase();
//                 final category = job['category'] ?? '';
//                 final matchesSearch = title.contains(search);
//                 final matchesCategory = selectedCategory == "All" || category == selectedCategory;
//                 final isExpired = _isJobExpired(job);
//                 return matchesSearch && matchesCategory && !isExpired;
//               }).toList();

//               // Also include hardcoded jobs if no firestore jobs
//               final combinedJobs = allFirestoreJobs.isEmpty
//                   ? allJobs.where((job) {
//                       final title = job['title'].toLowerCase();
//                       final category = job['category'];
//                       return title.contains(search) &&
//                           (selectedCategory == "All" || category == selectedCategory);
//                     }).toList()
//                   : filtered;

//               if (combinedJobs.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search_off, size: 60, color: Colors.grey),
//                       SizedBox(height: 10),
//                       Text("No jobs found",
//                           style: TextStyle(color: Colors.grey)),
//                       SizedBox(height: 4),
//                       Text("Try different search or category",
//                           style: TextStyle(color: Colors.grey[400], fontSize: 12)),
//                     ],
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 itemCount: combinedJobs.length,
//                 itemBuilder: (context, index) {
//                   final job = combinedJobs[index];
//                   return _buildJobCard(job, context);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//      Widget _buildJobCard(Map<String, dynamic> job, BuildContext context) {
//   final categoryColors = {
//     'Construction': Colors.brown,
//     'Electrical': Colors.yellow[800],
//     'Delivery': Colors.blue,
//     'Plumbing': Colors.teal,
//     'Painting': Colors.purple,
//     'Carpenter': Colors.brown,
//     'Welder': Colors.red,
//     'Other': Colors.grey,
//   };

//   final color = categoryColors[job['category']] ?? Colors.orange;

//   // ✅ NEW: distance calculation
//   double? distance = _getDistance(job);

//   // Get deadline info
//   String deadlineText = '';
//   bool isExpiringSoon = false;

//   if (job['endDate'] != null) {
//     try {
//       DateTime endDate;

//       if (job['endDate'] is Timestamp) {
//         endDate = (job['endDate'] as Timestamp).toDate();
//       } else {
//         endDate = job['endDate'] as DateTime;
//       }

//       final now = DateTime.now();
//       final daysLeft = endDate.difference(now).inDays;

//       if (daysLeft < 0) {
//         deadlineText = 'Expired';
//       } else if (daysLeft == 0) {
//         deadlineText = 'Expires today';
//         isExpiringSoon = true;
//       } else if (daysLeft <= 3) {
//         deadlineText = 'Expires in $daysLeft days';
//         isExpiringSoon = true;
//       } else {
//         deadlineText = 'Deadline: ${_formatDate(job['endDate'])}';
//       }
//     } catch (e) {
//       deadlineText = '';
//     }
//   }

  

//   return Container(
//     margin: EdgeInsets.only(bottom: 12),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.07),
//           blurRadius: 8,
//           offset: Offset(0, 2),
//         )
//       ],
//     ),
//     child: Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           // ── TOP ROW ──
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(Icons.work, color: color, size: 24),
//               ),
//               SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       job['title'] ?? '',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       job['employerName'] ??
//                           job['employer'] ??
//                           'Employer',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.green[200]!),
//                 ),
//                 child: Text(
//                   "₹${job['wage']}/day",
//                   style: TextStyle(
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 12),

//           // ── LOCATION + DISTANCE (UPDATED PART) ──
//           Row(
//             children: [
//               Icon(Icons.location_on, size: 14, color: Colors.grey),
//               SizedBox(width: 4),

//               Expanded(
//                 child: Text(
//                   distance != null
//                       ? "${job['location']} • ${distance.toStringAsFixed(2)} km away"
//                       : job['location'] ?? '',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 6),

//           // ── SHIFT + WORKERS ──
//           Row(
//             children: [
//               Icon(Icons.access_time, size: 14, color: Colors.grey),
//               SizedBox(width: 4),
//               Text(
//                 job['shift'] ?? '',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//               ),

//               if (job['workersNeeded'] != null) ...[
//                 SizedBox(width: 16),
//                 Icon(Icons.people, size: 14, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text(
//                   "${job['workersNeeded']} workers needed",
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ],
//           ),

//           // ── DEADLINE ──
//           if (deadlineText.isNotEmpty) ...[
//             SizedBox(height: 8),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: isExpiringSoon
//                     ? Colors.red[50]
//                     : Colors.orange[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.calendar_today,
//                       size: 12,
//                       color: isExpiringSoon
//                           ? Colors.red
//                           : Colors.orange),
//                   SizedBox(width: 4),
//                   Text(
//                     deadlineText,
//                     style: TextStyle(
//                       color: isExpiringSoon
//                           ? Colors.red[700]
//                           : Colors.orange[700],
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],

//           SizedBox(height: 12),

//           // ── CATEGORY + BUTTON ──
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   job['category'] ?? 'Other',
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),

//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           JobDetailScreen(jobData: job),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Text("View Job",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
//    }


import '../services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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

  double? userLat;
  double? userLng;
  bool isLocationLoaded = false;

  final categories = [
    "All",
    "Construction",
    "Electrical",
    "Delivery",
    "Plumbing",
    "Painting",
    "Carpenter",
    "Welder",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  /// LOAD USER LOCATION
  Future<void> _loadUserLocation() async {

    Position? pos =
        await LocationService.getUserLocation();

    if (pos != null) {

      setState(() {

        userLat = pos.latitude;
        userLng = pos.longitude;
      });
    }
  }

  /// CALCULATE DISTANCE
  // double? _getDistance(
  //     Map<String, dynamic> job,
  //     ) {

  //   if (userLat == null || userLng == null) {
  //     return null;
  //   }

  //   if (job['lat'] == null ||
  //       job['lng'] == null) {
  //     return null;
  //   }

  //   try {

  //     return LocationService.calculateDistance(
  //       userLat!,
  //       userLng!,
  //       (job['lat'] as num).toDouble(),
  //       (job['lng'] as num).toDouble(),
  //     );

  //   } catch (e) {

  //     print("Distance Error: $e");

  //     return null;
  //   }
  // }

//   double? _getDistance(
//   Map<String, dynamic> job,
// ) {

//   if (userLat == null || userLng == null) {
//     return null;
//   }

//   if (job['lat'] == null ||
//       job['lng'] == null) {
//     return null;
//   }

//   try {

//     double jobLat =
//         (job['lat'] as num).toDouble();

//     double jobLng =
//         (job['lng'] as num).toDouble();

//     return LocationService.calculateDistance(
//       userLat!,
//       userLng!,
//       jobLat,
//       jobLng,
//     );

//   } catch (e) {

//     print("Distance Error: $e");

//     return null;
//   }
// }

// double? _getDistance(Map<String, dynamic> job) {
//   // 1. Check if worker's GPS is ready
//   if (userLat == null || userLng == null) return null;

//   // 2. Check if this specific job has coordinates in Firebase
//   if (job['lat'] == null || job['lng'] == null) return null;

//   try {
//     // 3. Convert Firebase 'number' type to Dart 'double' safely
//     double jobLat = (job['lat'] as num).toDouble();
//     double jobLng = (job['lng'] as num).toDouble();

//     // 4. Return the calculated distance
//     return LocationService.calculateDistance(
//       userLat!,
//       userLng!,
//       jobLat,
//       jobLng,
//     );
//   } catch (e) {
//     print("Distance Calculation Error: $e");
//     return null;
//   }
// }

double? _getDistance(Map<String, dynamic> job) {
  // 1. Check if worker's GPS is ready
  if (userLat == null || userLng == null) {
    print("Distance Debug: Worker GPS is still NULL");
    return null;
  }

  // 2. Check if this specific job has coordinates in Firebase
  if (job['lat'] == null || job['lng'] == null) {
    print("Distance Debug: Job ${job['title']} is missing Lat/Lng in Firebase");
    return null;
  }

  try {
    // 3. Convert Firebase 'number' type to Dart 'double' safely
    // (num) handles both int and double from Firestore
    double jobLat = (job['lat'] as num).toDouble();
    double jobLng = (job['lng'] as num).toDouble();

    // 4. Return the calculated distance
    return LocationService.calculateDistance(
      userLat!,
      userLng!,
      jobLat,
      jobLng,
    );
  } catch (e) {
    print("Distance Calculation Error: $e");
    return null;
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      drawer: _buildDrawer(context),

      appBar: AppBar(

        backgroundColor: Colors.orange,
        elevation: 0,

        title: Row(
          children: [

            Icon(
              Icons.work,
              color: Colors.white,
            ),

            SizedBox(width: 8),

            Text(
              "RozgarLink",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NotificationScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProfileScreen(),
                ),
              );
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

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {

          setState(() {

            _currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Saved",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Applied",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Learn",
          ),
        ],
      ),
    );
  }

  /// JOB SCREEN
  Widget _buildJobsScreen() {

    return Column(
      children: [

        /// HEADER
        Container(

          width: double.infinity,

          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            20,
          ),

          decoration: BoxDecoration(
            color: Colors.orange,

            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                "Find Daily Work",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4),

              Text(
                "Jobs posted by employers",

                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: 16),

              /// SEARCH
              Container(

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: TextField(

                  decoration: InputDecoration(
                    hintText: "Search jobs...",

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),

                    border: InputBorder.none,
                  ),

                  onChanged: (value) {

                    setState(() {

                      search =
                          value.toLowerCase();
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        /// CATEGORY CHIPS
        SizedBox(
          height: 40,

          child: ListView.builder(

            scrollDirection: Axis.horizontal,

            padding:
                EdgeInsets.symmetric(horizontal: 12),

            itemCount: categories.length,

            itemBuilder: (_, index) {

              final cat = categories[index];

              bool isSelected =
                  selectedCategory == cat;

              return Padding(

                padding: EdgeInsets.only(right: 8),

                child: GestureDetector(

                  onTap: () {

                    setState(() {

                      selectedCategory = cat;
                    });
                  },

                  child: Container(

                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(

                      color: isSelected
                          ? Colors.orange
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      cat,

                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 8),

        /// JOB LIST
        Expanded(

          child: StreamBuilder<QuerySnapshot>(

            stream: FirebaseFirestore.instance
                .collection('jobs')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),

            builder: (context, snapshot) {

              if (!snapshot.hasData) {

                return Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              final jobs = snapshot.data!.docs;

jobs.sort((a, b) {

  final jobA =
      a.data() as Map<String, dynamic>;

  final jobB =
      b.data() as Map<String, dynamic>;

  double distanceA =
      _getDistance(jobA) ?? 999999;

  double distanceB =
      _getDistance(jobB) ?? 999999;

  return distanceA.compareTo(distanceB);
});

              if (jobs.isEmpty) {

                return Center(
                  child: Text("No jobs found"),
                );
              }

              return ListView.builder(

                padding:
                    EdgeInsets.symmetric(horizontal: 12),

                itemCount: jobs.length,

                itemBuilder: (context, index) {

                  final job =
                      jobs[index].data()
                          as Map<String, dynamic>;

                  /// FILTER SEARCH
                  if (search.isNotEmpty &&
                      !(job['title'] ?? '')
                          .toString()
                          .toLowerCase()
                          .contains(search)) {

                    return SizedBox();
                  }

                  /// FILTER CATEGORY
                  if (selectedCategory != "All" &&
                      job['category'] !=
                          selectedCategory) {

                    return SizedBox();
                  }

                  return _buildJobCard(
                    job,
                    context,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// JOB CARD
  // Widget _buildJobCard(
  //   Map<String, dynamic> job,
  //   BuildContext context,
  // ) {

  //   double? distance =
  //       _getDistance(job);

  //   return Container(

  //     margin: EdgeInsets.only(bottom: 12),

  //     decoration: BoxDecoration(

  //       color: Colors.white,

  //       borderRadius:
  //           BorderRadius.circular(16),

  //       boxShadow: [

  //         BoxShadow(
  //           color:
  //               Colors.black.withOpacity(0.06),

  //           blurRadius: 8,

  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),

  //     child: Padding(

  //       padding: EdgeInsets.all(16),

  //       child: Column(

  //         crossAxisAlignment:
  //             CrossAxisAlignment.start,

  //         children: [

  //           /// TOP ROW
  //           Row(
  //             children: [

  //               Container(

  //                 padding: EdgeInsets.all(10),

  //                 decoration: BoxDecoration(
  //                   color:
  //                       Colors.orange.withOpacity(0.1),

  //                   borderRadius:
  //                       BorderRadius.circular(12),
  //                 ),

  //                 child: Icon(
  //                   Icons.work,
  //                   color: Colors.orange,
  //                 ),
  //               ),

  //               SizedBox(width: 12),

  //               Expanded(

  //                 child: Column(

  //                   crossAxisAlignment:
  //                       CrossAxisAlignment.start,

  //                   children: [

  //                     Text(
  //                       job['title'] ?? '',

  //                       style: TextStyle(
  //                         fontWeight:
  //                             FontWeight.bold,

  //                         fontSize: 17,
  //                       ),
  //                     ),

  //                     SizedBox(height: 3),

  //                     Text(
  //                       job['employerName'] ??
  //                           'Employer',

  //                       style: TextStyle(
  //                         color: Colors.grey,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //               Container(

  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 12,
  //                   vertical: 6,
  //                 ),

  //                 decoration: BoxDecoration(
  //                   color: Colors.green[50],

  //                   borderRadius:
  //                       BorderRadius.circular(10),
  //                 ),

  //                 child: Text(

  //                   "₹${job['wage']}/day",

  //                   style: TextStyle(
  //                     color: Colors.green,
  //                     fontWeight:
  //                         FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),

  //           SizedBox(height: 12),

  //           /// LOCATION + DISTANCE
  //           Row(
  //             children: [

  //               Icon(
  //                 Icons.location_on,
  //                 size: 16,
  //                 color: Colors.orange,
  //               ),

  //               SizedBox(width: 4),

  //               Expanded(

  //                 child: Text(

  //                   distance != null
  //                       ? "${job['location']} • ${distance.toStringAsFixed(2)} KM Away"
  //                       : "${job['location']}",

  //                   style: TextStyle(
  //                     color: Colors.grey[700],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),

  //           SizedBox(height: 10),

  //           /// CATEGORY
  //           Container(

  //             padding: EdgeInsets.symmetric(
  //               horizontal: 10,
  //               vertical: 5,
  //             ),

  //             decoration: BoxDecoration(
  //               color:
  //                   Colors.orange.withOpacity(0.1),

  //               borderRadius:
  //                   BorderRadius.circular(20),
  //             ),

  //             child: Text(
  //               job['category'] ?? '',

  //               style: TextStyle(
  //                 color: Colors.orange,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),

  //           SizedBox(height: 14),

  //           /// BUTTON
  //           Align(

  //             alignment: Alignment.centerRight,

  //             child: ElevatedButton(

  //               style:
  //                   ElevatedButton.styleFrom(
  //                 backgroundColor:
  //                     Colors.orange,
  //               ),

  //               onPressed: () {

  //                 Navigator.push(
  //                   context,

  //                   MaterialPageRoute(
  //                     builder: (_) =>
  //                         JobDetailScreen(
  //                       jobData: job,
  //                     ),
  //                   ),
  //                 );
  //               },

  //               child: Text(
  //                 "View Job",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// UPDATED JOB CARD
  Widget _buildJobCard(Map<String, dynamic> job, BuildContext context) {
  // Call the distance function
  double? distance = _getDistance(job);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE & WAGE ROW
          Row(
            children: [
              Expanded(
                child: Text(
                  job['title'] ?? 'Job Title',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Text(
                "₹${job['wage'] ?? job['salary']}/day", // Pulls wage from DB
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// LOCATION & DISTANCE OUTPUT
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  distance != null
                      ? "${job['location']} • ${distance.toStringAsFixed(1)} KM Away"
                      : "${job['location'] ?? 'Location N/A'}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// VIEW JOB BUTTON
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          //     onPressed: () {
          //       // Navigate to details
          //     },
          //     child: const Text("View Job", style: TextStyle(color: Colors.white)),
          //   ),
          // ),

          /// VIEW JOB BUTTON
Align(
  alignment: Alignment.centerRight,

  child: ElevatedButton(

    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
    ),

    onPressed: () {

      print("VIEW JOB CLICKED");

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (context) =>
              JobDetailScreen(
            jobData: job,
          ),
        ),
      );
    },

    child: const Text(
      "View Job",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
),
        ],
      ),
    ),
  );
  
}

  /// DRAWER
  Widget _buildDrawer(
      BuildContext context,
      ) {

    return Drawer(

      child: ListView(

        children: [

          DrawerHeader(

            decoration: BoxDecoration(
              color: Colors.orange,
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisAlignment:
                  MainAxisAlignment.end,

              children: [

                CircleAvatar(
                  radius: 28,

                  backgroundColor:
                      Colors.white,

                  child: Icon(
                    Icons.person,
                    color: Colors.orange,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Welcome Worker",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}