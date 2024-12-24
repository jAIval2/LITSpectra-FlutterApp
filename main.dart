import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import the generated Firebase options
import 'screens/launch_screen.dart'; // Adjust the import based on your project structure
import 'screens/intro_slides.dart'; // Import the IntroSlides screen
import 'screens/dashboard.dart'; // Import the Dashboard screen
import 'screens/login_signup.dart'; // Import the LoginSignup screen
import 'screens/pattern_lock.dart'; // Import the Pattern Lock screen
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with platform-specific options
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  runApp(MyApp(email: email, password: password));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;

  MyApp({this.email, this.password});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LITSpectra',
      theme: ThemeData(
        primaryColor: Color(0xFF87CBB9),
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => LaunchScreen(), // Define the launch screen route
        '/intro_slides': (context) => IntroSlides(), // Define the intro slides route
        '/dashboard': (context) => DashboardScreen(), // Dashboard route
        '/login_signup': (context) => LoginSignupScreen(), // Login/Signup route
        '/pattern_lock': (context) => PatternLockScreen(), // Add this line
      },
    );
  }
}
