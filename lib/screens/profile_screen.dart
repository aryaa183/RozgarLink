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

  // 🔥 RESET EVERYTHING
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
      SnackBar(content: Text("Profile reset successfully")),
    );
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
            onPressed: resetAll,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 USER INFO
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
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? "Guest User",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Text("📸 Profile Photo Editor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            // IMAGE BOX
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
                        ? Image.memory(_webImage!, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 100))
                        : (_image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 100)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CONTROLS
            Column(
              children: [
                slider("Zoom", scale, 0.5, 3, (v) => setState(() => scale = v)),
                slider("Rotate", rotation, -3.14, 3.14, (v) => setState(() => rotation = v)),
                slider("Move X", x, -100, 100, (v) => setState(() => x = v)),
                slider("Move Y", y, -100, 100, (v) => setState(() => y = v)),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: Text("Gallery"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    child: Text("Camera"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: resetAll,
              child: Text("Reset All"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }

  Widget slider(String title, double value, double min,
      double max, Function(double) f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(value: value, min: min, max: max, onChanged: f),
      ],
    );
  }
}