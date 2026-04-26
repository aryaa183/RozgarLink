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

  final List<Map<String, dynamic>> skills = [
    {
      "title": "Construction Safety",
      "icon": Icons.construction,
      "color": Colors.brown,
      "video": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
      "tips": [
        "Always wear helmet and gloves on site",
        "Check all equipment before use",
        "Follow supervisor instructions strictly",
        "Never work at unsafe heights without harness",
      ]
    },
    {
      "title": "Electrical Work",
      "icon": Icons.electrical_services,
      "color": Colors.yellow[800],
      "video": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
      "tips": [
        "Always turn off power supply before working",
        "Use insulated tools only",
        "Never work with wet hands",
        "Double-check all wiring connections",
      ]
    },
    {
      "title": "Plumbing Basics",
      "icon": Icons.water_drop,
      "color": Colors.blue,
      "video": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
      "tips": [
        "Identify leakage points before repair",
        "Use correct pipe fittings",
        "Shut off water supply before starting",
        "Keep tools organized and clean",
      ]
    },
    {
      "title": "Delivery Job Guide",
      "icon": Icons.delivery_dining,
      "color": Colors.green,
      "video": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
      "tips": [
        "Plan your route before starting",
        "Always keep customer contact ready",
        "Handle packages with care",
        "Update delivery status in real time",
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(skills[_selectedIndex]['video']),
    )..initialize().then((_) {
        setState(() {});
        _videoController.addListener(() {
          if (mounted) {
            setState(() {
              _position = _videoController.value.position;
              _duration = _videoController.value.duration;
            });
          }
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
      _position = Duration.zero;
      _duration = Duration.zero;
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
            UrlSource(skills[_selectedIndex]['audio']));
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
    final skill = skills[_selectedIndex];
    final Color skillColor = skill['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [

          // ── SLIVER APP BAR ──────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.orange,
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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Icon(Icons.school_rounded,
                              size: 50, color: Colors.white),
                          SizedBox(height: 8),
                          Text("Skill Training",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          Text("Learn & grow your skills",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
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

                  // ── SKILL SELECTOR ──────────────
                  Text("Select Skill",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 12),

                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: skills.length,
                      itemBuilder: (_, i) {
                        final s = skills[i];
                        final c = s['color'] as Color;
                        final isSelected = _selectedIndex == i;
                        return GestureDetector(
                          onTap: () => _changeSkill(i),
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: [
                                      Colors.orange[700]!,
                                      Colors.deepOrange[400]!
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.white,
                                      Colors.white
                                    ]),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.grey[200]!,
                                  width: 2),
                              boxShadow: [
                                BoxShadow(
                                    color: isSelected
                                        ? Colors.orange.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 8)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(s['icon'] as IconData,
                                    color: isSelected ? Colors.white : c,
                                    size: 28),
                                SizedBox(height: 6),
                                Text(s['title'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── VIDEO PLAYER ────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5))
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        // Video
                        _videoController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController))
                            : Container(
                                height: 200,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.orange))),

                        // Progress Bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.orange,
                              thumbColor: Colors.orange,
                              inactiveTrackColor:
                                  Colors.grey[700],
                              trackHeight: 3,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble() > 0
                                  ? _duration.inSeconds.toDouble()
                                  : 1,
                              onChanged: (v) => _videoController
                                  .seekTo(Duration(seconds: v.toInt())),
                            ),
                          ),
                        ),

                        // Time + Controls
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Row(
                            children: [
                              Text(format(_position),
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12)),
                              Spacer(),
                              // Controls
                              IconButton(
                                icon: Icon(Icons.replay_10,
                                    color: Colors.white, size: 28),
                                onPressed: () =>
                                    _videoController.seekTo(_position -
                                        Duration(seconds: 10)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _videoController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _videoController.value.isPlaying
                                          ? _videoController.pause()
                                          : _videoController.play();
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.forward_10,
                                    color: Colors.white, size: 28),
                                onPressed: () =>
                                    _videoController.seekTo(_position +
                                        Duration(seconds: 10)),
                              ),
                              Spacer(),
                              Text(format(_duration),
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── AUDIO PLAYER ────────────────
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
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[700]!,
                                Colors.deepOrange[400]!
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.headphones_rounded,
                              color: Colors.white, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Audio Guide",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(height: 2),
                              Text(
                                _audioPlaying
                                    ? "Now playing..."
                                    : "Tap to listen to audio brief",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12),
                              ),
                              if (_audioPlaying) ...[
                                SizedBox(height: 6),
                                Row(
                                  children: List.generate(
                                    20,
                                    (i) => Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 1),
                                        height: (i % 3 + 1) * 4.0,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: _toggleAudio,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _audioPlaying
                                  ? Colors.red[50]
                                  : Colors.orange[50],
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _audioPlaying
                                      ? Colors.red
                                      : Colors.orange,
                                  width: 2),
                            ),
                            child: Icon(
                              _audioPlaying
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded,
                              color: _audioPlaying
                                  ? Colors.red
                                  : Colors.orange,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── QUICK TIPS ──────────────────
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: skillColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.lightbulb_rounded,
                            color: skillColor, size: 20),
                      ),
                      SizedBox(width: 10),
                      Text("Quick Tips",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),

                  SizedBox(height: 12),

                  ...List.generate(
                    (skill['tips'] as List).length,
                    (i) => Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: skillColor.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: skillColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text("${i + 1}",
                                  style: TextStyle(
                                      color: skillColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              skill['tips'][i],
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
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
}