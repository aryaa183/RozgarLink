import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  double scale = 1;
  double rotation = 0;
  double x = 0;
  double y = 0;

  final user = FirebaseAuth.instance.currentUser;

  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _image = File(picked.path));
      }
      // Reset transforms when new image picked
      setState(() { scale = 1; rotation = 0; x = 0; y = 0; });
    }
  }

  void resetAll() {
    setState(() {
      _image = null;
      _webImage = null;
      scale = 1;
      rotation = 0;
      x = 0;
      y = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile reset successfully"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 16),
            Text("Choose Photo Source",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sourceBtn(Icons.photo_library_rounded,
                    "Gallery", Colors.blue, () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                }),
                _sourceBtn(Icons.camera_alt_rounded,
                    "Camera", Colors.orange, () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                }),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sourceBtn(IconData icon, String label,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [

          // ── SLIVER APP BAR ───────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.orange,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: resetAll,
                tooltip: "Reset All",
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[800]!, Colors.deepOrange[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background circles
                    Positioned(top: -30, right: -30,
                      child: Container(width: 150, height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08)))),
                    Positioned(bottom: -20, left: -20,
                      child: Container(width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06)))),
                    // Profile info
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 3)),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  Colors.white.withOpacity(0.3),
                              child: Icon(Icons.person,
                                  size: 44, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            user?.displayName ?? "Worker Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user?.email ?? "guest@rozgarlink.com",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12),
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

                  // ── PHOTO EDITOR TITLE ────────────
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.photo_camera,
                            color: Colors.orange, size: 20),
                      ),
                      SizedBox(width: 10),
                      Text("Profile Photo Editor",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),

                  SizedBox(height: 4),
                  Text("Pick a photo and transform it using the sliders",
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12)),

                  SizedBox(height: 16),

                  // ── IMAGE BOX ─────────────────────
                  Center(
                    child: Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[200]!, Colors.grey[100]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.orange, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 15,
                              offset: Offset(0, 5))
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Transformed image
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(x, y)
                              ..rotateZ(rotation)
                              ..scale(scale),
                            alignment: Alignment.center,
                            child: kIsWeb
                                ? (_webImage != null
                                    ? Image.memory(_webImage!,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.cover)
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate,
                                              size: 70,
                                              color: Colors.grey[400]),
                                          SizedBox(height: 8),
                                          Text("Tap below to add photo",
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 13)),
                                        ],
                                      ))
                                : (_image != null
                                    ? Image.file(_image!,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.cover)
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate,
                                              size: 70,
                                              color: Colors.grey[400]),
                                          SizedBox(height: 8),
                                          Text("Tap below to add photo",
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 13)),
                                        ],
                                      )),
                          ),
                          // Transform badge
                          Positioned(
                            top: 8, right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "S:${scale.toStringAsFixed(1)}x  R:${(rotation * 57.3).toStringAsFixed(0)}°",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Pick Photo Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[700]!, Colors.deepOrange[400]!],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      label: Text("Pick / Change Photo",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ── TRANSFORMATION CONTROLS ───────
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
                        Text("Transformation Controls",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        SizedBox(height: 4),
                        Text("Adjust scale, rotation and position",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12)),
                        SizedBox(height: 16),

                        _buildSlider("Zoom (Scale)",
                            "${scale.toStringAsFixed(2)}x",
                            scale, 0.3, 3.0, Colors.orange,
                            Icons.zoom_in,
                            (v) => setState(() => scale = v)),

                        _buildSlider("Rotation",
                            "${(rotation * 57.3).toStringAsFixed(1)}°",
                            rotation, -3.14, 3.14, Colors.purple,
                            Icons.rotate_right,
                            (v) => setState(() => rotation = v)),

                        _buildSlider("Move X (Horizontal)",
                            "${x.toStringAsFixed(0)}px",
                            x, -120, 120, Colors.blue,
                            Icons.swap_horiz,
                            (v) => setState(() => x = v)),

                        _buildSlider("Move Y (Vertical)",
                            "${y.toStringAsFixed(0)}px",
                            y, -120, 120, Colors.teal,
                            Icons.swap_vert,
                            (v) => setState(() => y = v)),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── QUICK BUTTONS ─────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _quickBtn("Rotate 90°",
                            Colors.purple, Icons.rotate_90_degrees_ccw,
                            () => setState(
                                () => rotation += 1.5708)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _quickBtn("Zoom In",
                            Colors.green, Icons.zoom_in,
                            () => setState(() =>
                                scale = (scale + 0.25).clamp(0.3, 3.0))),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _quickBtn("Zoom Out",
                            Colors.red, Icons.zoom_out,
                            () => setState(() =>
                                scale = (scale - 0.25).clamp(0.3, 3.0))),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: resetAll,
                      icon: Icon(Icons.refresh, color: Colors.red),
                      label: Text("Reset All Transformations",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ── SKILLS SECTION ────────────────
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[50]!, Colors.deepOrange[50]!],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.orange[200]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.construction,
                                color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text("Skills & Availability",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            "Construction",
                            "Plumbing",
                            "Painting",
                            "Tiling",
                            "Welding",
                          ]
                              .map((skill) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange[700]!,
                                          Colors.deepOrange[400]!
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(skill,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.green[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle),
                              ),
                              SizedBox(width: 6),
                              Text("Available for Work",
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildSlider(String label, String valueLabel,
      double value, double min, double max,
      Color color, IconData icon, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87)),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(valueLabel,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withOpacity(0.15),
            overlayColor: color.withOpacity(0.1),
            trackHeight: 4,
          ),
          child: Slider(
              value: value, min: min, max: max, onChanged: onChanged),
        ),
        Divider(height: 8),
      ],
    );
  }

  Widget _quickBtn(String label, Color color,
      IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        shadowColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color.withOpacity(0.4)),
        ),
      ),
    );
  }
}