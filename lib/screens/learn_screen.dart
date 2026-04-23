// lib/screens/learn_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _selectedIndex = 0;
  bool _audioPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // 🔥 PROFESSIONAL CONTENT
  final List<Map<String, dynamic>> skills = [
    {
      "title": "Construction Safety",
      "video":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "audio":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
      "tips": [
        "Wear helmet and gloves",
        "Check equipment before use",
        "Follow supervisor instructions",
        "Avoid unsafe heights"
      ]
    },
    {
      "title": "Electrical Work",
      "video":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "audio":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
      "tips": [
        "Turn off power supply",
        "Use insulated tools",
        "Avoid wet hands",
        "Check wiring carefully"
      ]
    },
    {
      "title": "Plumbing Basics",
      "video":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      "audio":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
      "tips": [
        "Check leakage points",
        "Use proper pipe fittings",
        "Turn off water before repair",
        "Keep tools organized"
      ]
    },
    {
      "title": "Delivery Job Guide",
      "video":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
      "audio":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
      "tips": [
        "Plan route in advance",
        "Keep customer contact ready",
        "Handle items carefully",
        "Track delivery status"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _videoController = VideoPlayerController.network(
      skills[_selectedIndex]['video'],
    )..initialize().then((_) {
        setState(() {});
        _videoController.addListener(() {
          setState(() {
            _position = _videoController.value.position;
            _duration = _videoController.value.duration;
          });
        });
      });
  }

  void _changeSkill(int index) {
    _videoController.pause();
    _videoController.dispose();
    _audioPlayer.stop();

    setState(() {
      _selectedIndex = index;
      _audioPlaying = false;
    });

    _loadVideo();
  }

  void _toggleAudio() async {
    try {
      if (_audioPlaying) {
        await _audioPlayer.stop();
        setState(() => _audioPlaying = false);
      } else {
        await _audioPlayer.play(
          UrlSource(skills[_selectedIndex]['audio']),
        );
        setState(() => _audioPlaying = true);
      }
    } catch (e) {
      print("Audio error: $e");
    }
  }

  String format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = skills[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Skill Training"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Select Skill",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: List.generate(skills.length, (i) {
                return ChoiceChip(
                  label: Text(skills[i]['title']),
                  selected: _selectedIndex == i,
                  selectedColor: Colors.orange,
                  onSelected: (_) => _changeSkill(i),
                );
              }),
            ),

            SizedBox(height: 15),

            // 🎥 VIDEO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio:
                          _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : Container(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),

            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble() > 0
                  ? _duration.inSeconds.toDouble()
                  : 1,
              activeColor: Colors.orange,
              onChanged: (v) {
                _videoController.seekTo(
                    Duration(seconds: v.toInt()));
              },
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(format(_position)),
                Text(format(_duration)),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10),
                  onPressed: () => _videoController.seekTo(
                      _position - Duration(seconds: 10)),
                ),
                IconButton(
                  icon: Icon(
                    _videoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _videoController.value.isPlaying
                          ? _videoController.pause()
                          : _videoController.play();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.forward_10),
                  onPressed: () => _videoController.seekTo(
                      _position + Duration(seconds: 10)),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🎧 AUDIO
            Card(
              child: ListTile(
                leading: Icon(Icons.headphones,
                    color: Colors.orange),
                title: Text("Audio Guide"),
                subtitle: Text(_audioPlaying
                    ? "Playing..."
                    : "Tap to listen"),
                trailing: IconButton(
                  icon: Icon(
                    _audioPlaying
                        ? Icons.stop
                        : Icons.play_arrow,
                    color: Colors.orange,
                  ),
                  onPressed: _toggleAudio,
                ),
              ),
            ),

            SizedBox(height: 20),

            // 💡 TIPS
            Text("Quick Tips",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: data['tips']
                      .map<Widget>((tip) => Text("• $tip"))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}