import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon1/helper/pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/splash_screen.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Firebase
    await Firebase.initializeApp();
    // Initialize Hive preferences
    await pref.initialize();
    // Set system UI mode
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Set orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    runApp(const MyApp());
  } catch (e) {
    print('Initialization error: $e');
  }
}

// Adding the MyApp class definition
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}