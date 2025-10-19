import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cult_radio/services/firebase_service.dart';
import 'package:cult_radio/widgets/player_controls.dart';
import 'package:cult_radio/widgets/program_info.dart';
import 'package:cult_radio/widgets/schedule_list.dart';

class RadioPlayerPage extends StatefulWidget {
  @override
  _RadioPlayerPageState createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  late YoutubePlayerController _youtubeController;
  late FirebaseService _firebaseService;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _setupYoutubePlayer();
  }

  void _setupYoutubePlayer() {
    _youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        hideControls: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Cult Radio'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _firebaseService.radioDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          final isLive = data['is_live'] ?? false;
          final streamUrl = data['current_stream_url'] ?? '';
          final metadata = data['program_metadata'] ?? {};
          final schedule = data['schedule'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // YouTube Player
                if (streamUrl.isNotEmpty && isLive)
                  _buildYouTubePlayer(streamUrl),

                // Player Controls
                PlayerControls(
                  isLive: isLive,
                  onPlay: () => _youtubeController.play(),
                  onPause: () => _youtubeController.pause(),
                  onStop: () => _youtubeController.pause(),
                ),

                const SizedBox(height: 20),

                // Program Information
                ProgramInfo(metadata: metadata),

                const SizedBox(height: 20),

                // Schedule List
                ScheduleList(schedule: schedule),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildYouTubePlayer(String streamUrl) {
    final videoId = YoutubePlayer.convertUrlToId(streamUrl);

    if (videoId != null) {
      if (_youtubeController.metadata.videoId != videoId) {
        _youtubeController.load(videoId);
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.deepPurple,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(Icons.live_tv, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text('Live Stream Available', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }
}
