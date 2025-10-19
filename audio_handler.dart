import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    // Set initial media item
    mediaItem.add(const MediaItem(
      id: 'cult_radio_stream',
      title: 'Cult Radio',
      artist: 'Live Streaming',
      genre: 'Radio',
      artUri: Uri.parse('https://example.com/radio_icon.png'),
    ));

    // Transform player events to audio service events
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // YouTube URL එක audio stream එකකට convert කිරීම
  Future<void> setAudioUrl(String youtubeUrl) async {
    try {
      // YouTube URL to audio stream conversion logic
      // දැනට, sample audio stream එකක් use කරමු
      final audioUrl = _convertYoutubeToAudio(youtubeUrl);

      await _player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));

      // Update media item
      mediaItem.add(const MediaItem(
        id: 'cult_radio_live',
        title: 'Cult Radio - Live',
        artist: 'Live Stream',
        genre: 'Radio',
        artUri: Uri.parse('https://example.com/radio_icon.png'),
      ));
    } catch (e) {
      print('Error setting audio URL: $e');
    }
  }

  String _convertYoutubeToAudio(String youtubeUrl) {
    // YouTube URL to audio stream conversion
    // දැනට, sample URL එක return කරමු
    // පසුව ඔබට YouTube Data API භාවිතා කර actual conversion කළ හැකිය
    return "https://example.com/audio_stream.mp3";
  }

  // Transform Just Audio events to Audio Service events
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
