import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Transformation values ──
  double _scale = 1.0;
  double _rotation = 0.0;
  double _translateX = 0.0;
  double _translateY = 0.0;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // ── Pick image from gallery ──
  Future<void> _pickFromGallery() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // ── Pick image from camera ──
  Future<void> _pickFromCamera() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // ── Reset all transformations ──
  void _reset() {
    setState(() {
      _scale = 1.0;
      _rotation = 0.0;
      _translateX = 0.0;
      _translateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: _reset,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Profile Info Card ──
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person,
                          size: 34, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Ramesh Kumar',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text('Skill: Construction Worker'),
                        Text('Location: Mumbai'),
                        Text('Rating: ⭐ 4.5'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Image Display Box ──
            const Text(
              '📸 Profile Photo Editor',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.orange, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  // ── THE 3 TRANSFORMATIONS ARE APPLIED HERE ──
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(_translateX, _translateY) // Translation
                      ..rotateZ(_rotation)                   // Rotation
                      ..scale(_scale),                       // Scaling
                    alignment: Alignment.center,
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.account_circle,
                                  size: 120, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Pick a photo below',
                                  style: TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Image Picker Buttons ──
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Transformation Controls ──
            const Text(
              '🎛️ Image Transformations',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    // ── SCALING ──
                    _buildSliderRow(
                      label: '🔍 Scale (Zoom)',
                      value: _scale,
                      min: 0.5,
                      max: 3.0,
                      displayValue: _scale.toStringAsFixed(2) + 'x',
                      color: Colors.orange,
                      onChanged: (v) => setState(() => _scale = v),
                    ),

                    const Divider(height: 24),

                    // ── ROTATION ──
                    _buildSliderRow(
                      label: '🔄 Rotation',
                      value: _rotation,
                      min: -3.14,
                      max: 3.14,
                      displayValue:
                          '${(_rotation * 57.3).toStringAsFixed(1)}°',
                      color: Colors.deepPurple,
                      onChanged: (v) => setState(() => _rotation = v),
                    ),

                    const Divider(height: 24),

                    // ── TRANSLATION X ──
                    _buildSliderRow(
                      label: '↔️ Move X (Translation)',
                      value: _translateX,
                      min: -120,
                      max: 120,
                      displayValue: _translateX.toStringAsFixed(1),
                      color: Colors.blue,
                      onChanged: (v) =>
                          setState(() => _translateX = v),
                    ),

                    const Divider(height: 24),

                    // ── TRANSLATION Y ──
                    _buildSliderRow(
                      label: '↕️ Move Y (Translation)',
                      value: _translateY,
                      min: -120,
                      max: 120,
                      displayValue: _translateY.toStringAsFixed(1),
                      color: Colors.teal,
                      onChanged: (v) =>
                          setState(() => _translateY = v),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Reset Button ──
            ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Transformations'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 8),

            // ── Info Card for Viva ──
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('ℹ️ Transformation Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(height: 8),
                    Text('• Scale: Zoom in (>1) or zoom out (<1)'),
                    Text('• Rotation: Rotate image clockwise/anticlockwise'),
                    Text('• Translation X: Move image left or right'),
                    Text('• Translation Y: Move image up or down'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Reusable slider row widget ──
  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(displayValue,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            inactiveTrackColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}