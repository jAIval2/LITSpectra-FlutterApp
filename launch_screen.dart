import 'package:flutter/material.dart';
import 'dart:async';
import 'dashboard.dart'; // Import the DashboardScreen
import 'intro_slides.dart'; // Import the IntroSlides screen


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'ProtoMono', color: Color(0xFFF1F0E1)),
          bodySmall: TextStyle(fontFamily: 'ProtoMono', color: Color(0xFFF1F0E1)),
        ),
      ),
      home: LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF101015), Color(0xFF506385)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Positioned text in the bottom left corner
          Positioned(
            left: 20,
            bottom: 100, // Adjust this value to position the text higher or lower
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "get lit up",
                  style: TextStyle(
                    fontFamily: 'ProtoMono',
                    fontSize: 24,
                    color: Color(0xFFF1F0E1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "LITSPECTRA",
                  style: TextStyle(
                    fontFamily: 'ProtoMono',
                    fontSize: 48,
                    color: Color(0xFFF1F0E1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Positioned circular button in the bottom right corner
          Positioned(
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to IntroSlides when the button is pressed
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => IntroSlides()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), // Make the button circular
                backgroundColor: Color(0xFF506385), // Button background color
                padding: EdgeInsets.all(20), // Adjust padding for size
              ),
              child: Icon(
                Icons.arrow_forward, // Use an icon for the button
                color: Colors.white,
                size: 30, // Adjust icon size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
