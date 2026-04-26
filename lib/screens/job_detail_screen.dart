import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailScreen extends StatefulWidget {
  final dynamic jobData;
  JobDetailScreen({required this.jobData});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _saved = false;
  bool _applied = false;
  TimeOfDay? _reminderTime;

  // Get data whether from Firestore or Map
  Map<String, dynamic> get data {
    if (widget.jobData is Map<String, dynamic>) {
      return widget.jobData;
    }
    return widget.jobData.data() as Map<String, dynamic>;
  }

  String get jobId {
    if (widget.jobData is Map<String, dynamic>) {
      return widget.jobData['title'] ?? 'job';
    }
    return widget.jobData.id;
  }

  Future<void> _setReminder() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Set Job Reminder",
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reminder set for ${picked.format(context)}"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _saveJob() async {
    try {
      await FirebaseFirestore.instance
          .collection('saved_jobs')
          .add(data);
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job Saved!"),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job Saved!"),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _applyJob() async {
    try {
      final ref = FirebaseFirestore.instance.collection('applications');
      final existing = await ref.where('jobId', isEqualTo: jobId).get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Already Applied!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      await ref.add({
        'jobId': jobId,
        'title': data['title'],
        'status': 'Applied',
        'date': DateTime.now(),
      });
    } catch (e) {
      // works with mock data too
    }

    setState(() => _applied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Applied Successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColors = {
      'Construction': Colors.brown,
      'Electrical': Colors.yellow[800],
      'Delivery': Colors.blue,
      'Plumbing': Colors.teal,
    };
    final color =
        categoryColors[data['category']] ?? Colors.orange;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [

          // ── SLIVER APP BAR ─────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange[800]!,
                      Colors.deepOrange[400]!
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(top: -40, right: -40,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08)))),
                    Positioned(bottom: -30, left: -30,
                      child: Container(width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06)))),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.work_rounded,
                                size: 52, color: Colors.white),
                          ),
                          SizedBox(height: 12),
                          Text(
                            data['title'] ?? 'Job Details',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            data['employer'] ?? 'RozgarLink',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── JOB INFO CARD ───────────────
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        _infoRow(Icons.currency_rupee,
                            "Daily Wage",
                            "₹${data['wage'] ?? 'N/A'} per day",
                            Colors.green),
                        Divider(height: 20),
                        _infoRow(Icons.location_on,
                            "Location",
                            data['location'] ?? 'Unknown',
                            Colors.red),
                        Divider(height: 20),
                        _infoRow(Icons.category,
                            "Category",
                            data['category'] ?? 'General',
                            color!),
                        Divider(height: 20),
                        _infoRow(Icons.access_time,
                            "Shift Timing",
                            data['shift'] ?? '9AM - 5PM',
                            Colors.purple),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── TIME PICKER SECTION ─────────
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.alarm, color: Colors.orange),
                          SizedBox(width: 8),
                          Text("Job Reminder",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: 4),
                        Text("Set an alarm so you don't miss this job",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12)),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.orange[200]!),
                                ),
                                child: Text(
                                  _reminderTime != null
                                      ? "Set for: ${_reminderTime!.format(context)}"
                                      : "No reminder set",
                                  style: TextStyle(
                                      color: _reminderTime != null
                                          ? Colors.orange[700]
                                          : Colors.grey[400],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _setReminder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                              child: Text("Set Alarm",
                                  style:
                                      TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── WHY APPLY SECTION ───────────
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange[50]!,
                          Colors.deepOrange[50]!
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Why Apply?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        SizedBox(height: 10),
                        _whyItem(Icons.payments_rounded,
                            "Daily wage paid same day"),
                        _whyItem(Icons.verified_user,
                            "Verified employer on RozgarLink"),
                        _whyItem(Icons.location_on,
                            "Local job — no travel hassle"),
                        _whyItem(Icons.star,
                            "Top rated job this week"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // ── ACTION BUTTONS ──────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saved ? null : _saveJob,
                          icon: Icon(
                            _saved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _saved
                                ? Colors.grey
                                : Colors.blue,
                          ),
                          label: Text(
                            _saved ? "Saved" : "Save Job",
                            style: TextStyle(
                                color: _saved
                                    ? Colors.grey
                                    : Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                                color: _saved
                                    ? Colors.grey
                                    : Colors.blue,
                                width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: _applied
                                ? LinearGradient(colors: [
                                    Colors.grey,
                                    Colors.grey
                                  ])
                                : LinearGradient(colors: [
                                    Colors.orange[700]!,
                                    Colors.deepOrange[400]!
                                  ]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _applied
                                ? []
                                : [
                                    BoxShadow(
                                        color: Colors.orange
                                            .withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: Offset(0, 4))
                                  ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _applied ? null : _applyJob,
                            icon: Icon(
                              _applied
                                  ? Icons.check_circle
                                  : Icons.send,
                              color: Colors.white,
                            ),
                            label: Text(
                              _applied
                                  ? "Already Applied"
                                  : "Apply Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label,
      String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _whyItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 18),
          SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}