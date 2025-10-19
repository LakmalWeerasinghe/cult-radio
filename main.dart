import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cult_radio/pages/radio_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "your-api-key",
      authDomain: "cultradio-38de8.firebaseapp.com",
      databaseURL: "https://cultradio-38de8-default-rtdb.firebaseio.com",
      projectId: "cultradio-38de8",
      storageBucket: "cultradio-38de8.appspot.com",
      messagingSenderId: "your-sender-id",
      appId: "your-app-id",
    ),
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
        useMaterial3: true,
      ),
      home: RadioPlayerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
