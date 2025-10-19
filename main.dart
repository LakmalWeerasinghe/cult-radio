import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cult_radio/pages/radio_player.dart';

// Firebase Configuration
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'your-api-key-here',
      appId: 'your-app-id-here',
      messagingSenderId: 'your-sender-id-here',
      projectId: 'cultradio-38de8',
      databaseURL: 'https://cultradio-38de8-default-rtdb.firebaseio.com/',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cult Radio',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: RadioPlayerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
