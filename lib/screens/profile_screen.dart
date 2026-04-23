import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // 📸 Pick Image
  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _image = File(picked.path));
      }
    }
  }

  // 🔄 Reset
  void reset() {
    setState(() {
      scale = 1;
      rotation = 0;
      x = 0;
      y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reset,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 WORKER PROFILE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.orange),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Ramesh Kumar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text("Skill: Construction Worker",
                          style: TextStyle(color: Colors.white70)),
                      Text("Location: Mumbai",
                          style: TextStyle(color: Colors.white70)),
                      Text("Rating: ⭐ 4.5",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 📸 TITLE
            const Text(
              "📸 Profile Photo Editor",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🖼️ IMAGE BOX
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(x, y)
                      ..rotateZ(rotation)
                      ..scale(scale),
                    alignment: Alignment.center,
                    child: kIsWeb
                        ? (_webImage != null
                        ? Image.memory(_webImage!,
                        fit: BoxFit.cover)
                        : const Icon(Icons.image,
                        size: 100, color: Colors.grey))
                        : (_image != null
                        ? Image.file(_image!,
                        fit: BoxFit.cover)
                        : const Icon(Icons.image,
                        size: 100, color: Colors.grey)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🎛️ CONTROLS
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Column(
                children: [

                  slider("🔍 Zoom", scale, 0.5, 3,
                          (v) => setState(() => scale = v)),

                  slider("🔄 Rotate", rotation, -3.14, 3.14,
                          (v) => setState(() => rotation = v)),

                  slider("↔ Move X", x, -100, 100,
                          (v) => setState(() => x = v)),

                  slider("↕ Move Y", y, -100, 100,
                          (v) => setState(() => y = v)),

                  const SizedBox(height: 10),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                          label: const Text("Gallery"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera),
                          label: const Text("Camera"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: reset,
                    child: const Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize:
                      const Size(double.infinity, 45),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔧 SLIDER
  Widget slider(String title, double value, double min,
      double max, Function(double) f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: Colors.orange,
          onChanged: f,
        ),
      ],
    );
  }
}