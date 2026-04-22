// // lib/screens/job_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class JobDetailScreen extends StatefulWidget {
//   final DocumentSnapshot jobData;
//   JobDetailScreen({required this.jobData});

//   @override
//   _JobDetailScreenState createState() =>
//     _JobDetailScreenState();
// }

// class _JobDetailScreenState extends State<JobDetailScreen> {
//   TimeOfDay? _reminderTime;
//   TimeOfDay? _shiftStartTime;
//   TimeOfDay? _shiftEndTime;
//   String _status = "Not Applied";
//   bool _reminderSet = false;

//   // Pick reminder time
//   Future<void> _setReminder() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       helpText: "Set Job Reminder Alarm",
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData(
//             colorScheme: ColorScheme.light(
//               primary: Colors.orange)),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         _reminderTime = picked;
//         _reminderSet = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "⏰ Reminder set for ${picked.format(context)}"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   // Pick shift start time
//   Future<void> _pickShiftStart() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: 7, minute: 0),
//       helpText: "Select Shift Start Time",
//     );
//     if (picked != null) {
//       setState(() => _shiftStartTime = picked);
//     }
//   }

//   // Pick shift end time
//   Future<void> _pickShiftEnd() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: 14, minute: 0),
//       helpText: "Select Shift End Time",
//     );
//     if (picked != null) {
//       setState(() => _shiftEndTime = picked);
//     }
//   }

//   // Apply for job
//   void _applyJob() {
//     setState(() => _status = "Applied ✅");
//     // Save to Firestore
//     FirebaseFirestore.instance.collection('applications').add({
//       'jobTitle': widget.jobData['title'],
//       'appliedAt': DateTime.now(),
//       'status': 'pending',
//       'shiftStart': _shiftStartTime?.format(context) ?? 'N/A',
//       'shiftEnd': _shiftEndTime?.format(context) ?? 'N/A',
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Application submitted successfully!"),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final job = widget.jobData;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Job Details"),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // ── Job Info Card ──
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                   children: [
//                     Text(job['title'],
//                       style: TextStyle(fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange)),
//                     SizedBox(height: 8),
//                     Row(children: [
//                       Icon(Icons.location_on,
//                         color: Colors.red, size: 18),
//                       Text(" ${job['location']}"),
//                     ]),
//                     SizedBox(height: 4),
//                     Row(children: [
//                       Icon(Icons.currency_rupee,
//                         color: Colors.green, size: 18),
//                       Text(" ${job['wage']} / day",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green)),
//                     ]),
//                     SizedBox(height: 4),
//                     Row(children: [
//                       Icon(Icons.category,
//                         color: Colors.blue, size: 18),
//                       Text(" ${job['category']}"),
//                     ]),
//                     SizedBox(height: 8),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _status == "Applied ✅"
//                           ? Colors.green[100]
//                           : Colors.orange[100],
//                         borderRadius:
//                           BorderRadius.circular(20)),
//                       child: Text("Status: $_status"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // ── TIME PICKER SECTION ──
//             Text("⏰ Time Settings",
//               style: TextStyle(fontSize: 18,
//               fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),

//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [

//                     // Shift Start
//                     ListTile(
//                       leading: Icon(Icons.access_time,
//                         color: Colors.orange),
//                       title: Text("Shift Start Time"),
//                       subtitle: Text(_shiftStartTime != null
//                         ? _shiftStartTime!.format(context)
//                         : "Not set"),
//                       trailing: ElevatedButton(
//                         onPressed: _pickShiftStart,
//                         child: Text("Pick"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange),
//                       ),
//                     ),

//                     Divider(),

//                     // Shift End
//                     ListTile(
//                       leading: Icon(Icons.access_time_filled,
//                         color: Colors.deepOrange),
//                       title: Text("Shift End Time"),
//                       subtitle: Text(_shiftEndTime != null
//                         ? _shiftEndTime!.format(context)
//                         : "Not set"),
//                       trailing: ElevatedButton(
//                         onPressed: _pickShiftEnd,
//                         child: Text("Pick"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange),
//                       ),
//                     ),

//                     Divider(),

//                     // Reminder Alarm
//                     ListTile(
//                       leading: Icon(Icons.alarm,
//                         color: _reminderSet
//                           ? Colors.green : Colors.grey),
//                       title: Text("Job Reminder Alarm"),
//                       subtitle: Text(_reminderSet
//                         ? "Set for: ${_reminderTime!
//                             .format(context)}"
//                         : "No reminder set"),
//                       trailing: ElevatedButton(
//                         onPressed: _setReminder,
//                         child: Text("Set Alarm"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // ── Apply Button ──
//             ElevatedButton.icon(
//               onPressed: _status == "Applied ✅"
//                 ? null : _applyJob,
//               icon: Icon(Icons.send),
//               label: Text(_status == "Applied ✅"
//                 ? "Already Applied" : "Apply for This Job"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 55),
//                 backgroundColor: Colors.orange,
//                 textStyle: TextStyle(fontSize: 18)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationScreen extends StatefulWidget {
  final DocumentSnapshot jobData;
  JobApplicationScreen({required this.jobData});

  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  TimeOfDay? _reminderTime;
  TimeOfDay? _shiftStartTime;
  TimeOfDay? _shiftEndTime;
  String _status = "Not Applied";
  bool _reminderSet = false;

  // Pick reminder time
  Future<void> _setReminder() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Set Job Reminder Alarm",
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Colors.orange)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
        _reminderSet = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⏰ Reminder set for ${picked.format(context)}"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Pick shift start time
  Future<void> _pickShiftStart() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 0),
      helpText: "Select Shift Start Time",
    );
    if (picked != null) {
      setState(() => _shiftStartTime = picked);
    }
  }

  // Pick shift end time
  Future<void> _pickShiftEnd() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 14, minute: 0),
      helpText: "Select Shift End Time",
    );
    if (picked != null) {
      setState(() => _shiftEndTime = picked);
    }
  }

  // Apply for job
  void _applyJob() {
    setState(() => _status = "Applied ✅");
    FirebaseFirestore.instance.collection('applications').add({
      'jobTitle': widget.jobData['title'],
      'appliedAt': DateTime.now(),
      'status': 'pending',
      'shiftStart': _shiftStartTime?.format(context) ?? 'N/A',
      'shiftEnd': _shiftEndTime?.format(context) ?? 'N/A',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Application submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.jobData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Job"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'],
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                    SizedBox(height: 8),
                    Row(children: [Icon(Icons.location_on, color: Colors.red, size: 18), Text(" ${job['location']}")]),
                    SizedBox(height: 4),
                    Row(children: [Icon(Icons.currency_rupee, color: Colors.green, size: 18), Text(" ${job['wage']} / day")]),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: _status == "Applied ✅" ? Colors.green[100] : Colors.orange[100],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Status: $_status"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("⏰ Time Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.access_time, color: Colors.orange),
                    title: Text("Shift Start Time"),
                    subtitle: Text(_shiftStartTime != null ? _shiftStartTime!.format(context) : "Not set"),
                    trailing: ElevatedButton(onPressed: _pickShiftStart, child: Text("Pick")),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.access_time_filled, color: Colors.deepOrange),
                    title: Text("Shift End Time"),
                    subtitle: Text(_shiftEndTime != null ? _shiftEndTime!.format(context) : "Not set"),
                    trailing: ElevatedButton(onPressed: _pickShiftEnd, child: Text("Pick")),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.alarm, color: _reminderSet ? Colors.green : Colors.grey),
                    title: Text("Job Reminder Alarm"),
                    subtitle: Text(_reminderSet ? "Set for: ${_reminderTime!.format(context)}" : "No reminder set"),
                    trailing: ElevatedButton(onPressed: _setReminder, child: Text("Set Alarm"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _status == "Applied ✅" ? null : _applyJob,
              icon: Icon(Icons.send),
              label: Text(_status == "Applied ✅" ? "Already Applied" : "Apply for This Job"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 55), backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}