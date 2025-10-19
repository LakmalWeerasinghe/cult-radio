import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream for real-time updates
  Stream<Map<dynamic, dynamic>> get radioDataStream {
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return data ?? {};
    });
  }

  // Get current stream URL
  Stream<String> get streamUrlStream {
    return _dbRef.child('current_stream_url').onValue.map((event) {
      return event.snapshot.value as String? ?? '';
    });
  }

  // Get live status
  Stream<bool> get liveStatusStream {
    return _dbRef.child('is_live').onValue.map((event) {
      return (event.snapshot.value as bool?) ?? false;
    });
  }

  // Get schedule
  Stream<List<dynamic>> get scheduleStream {
    return _dbRef.child('schedule').onValue.map((event) {
      final data = event.snapshot.value as List<dynamic>?;
      return data ?? [];
    });
  }

  // Get program metadata
  Stream<Map<dynamic, dynamic>> get metadataStream {
    return _dbRef.child('program_metadata').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return data ?? {};
    });
  }
}
