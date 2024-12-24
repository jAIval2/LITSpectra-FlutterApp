// lib/screens/pattern_lock.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternLockScreen extends StatefulWidget {
  @override
  _PatternLockScreenState createState() => _PatternLockScreenState();
}

class _PatternLockScreenState extends State<PatternLockScreen> {
  List<int> selectedTiles = []; // To track selected pattern tiles
  List<int> storedPattern = []; // To store the retrieved pattern
  bool isPatternSet = false; // To check if a pattern is already set
  int wrongAttempts = 0; // To track wrong attempts

  // Colors for the tiles when clicked
  final List<Color> selectedColors = [
    Color(0xFF857250),
    Color(0xFF628550),
    Color(0xFF506385),
    Color(0xFF855063),
  ];

  @override
  void initState() {
    super.initState();
    _loadPattern(); // Load the stored pattern when the screen initializes
  }

  Future<void> _loadPattern() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pattern = prefs.getString('pattern');
    if (pattern != null) {
      storedPattern = pattern.split(',').map(int.parse).toList();
      isPatternSet = true; // A pattern is already set
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101015), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPatternSet ? 'Enter Your Pattern Lock' : 'Set Your Pattern Lock',
              style: TextStyle(
                fontFamily: 'ProtoMono',
                fontSize: 24,
                color: Color(0xFFF1F0E1),
              ),
            ),
            SizedBox(height: 30),
            _buildPatternGrid(),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: selectedTiles.length == 4 ? _submitPattern : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF506385), // Button color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(
                  fontFamily: 'ProtoMono',
                  fontSize: 18,
                ),
              ),
              child: Text('Submit Pattern'),
            ),
            if (wrongAttempts >= 3) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPattern,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Reset button color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(
                    fontFamily: 'ProtoMono',
                    fontSize: 18,
                  ),
                ),
                child: Text('Reset Pattern'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatternGrid() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFF1F0E1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (col) {
              int tileIndex = row * 3 + col;
              return GestureDetector(
                onTap: () => _onTileTap(tileIndex),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: selectedTiles.contains(tileIndex)
                        ? selectedColors[selectedTiles.length % selectedColors.length]
                        : Color(0xFF506385), // Default tile color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFF1F0E1)),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  void _onTileTap(int index) {
    setState(() {
      if (selectedTiles.contains(index)) {
        selectedTiles.remove(index); // Remove tile if already selected
      } else if (selectedTiles.length < 4) {
        selectedTiles.add(index); // Add tile to pattern sequence
      }
    });
  }

  void _submitPattern() async {
    if (isPatternSet) {
      // Authenticate the entered pattern
      if (selectedTiles.toString() == storedPattern.toString()) {
        // Pattern matches
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Pattern does not match
        wrongAttempts++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect pattern. Please try again.')),
        );

        // If wrong attempts exceed 3, prompt to log in again
        if (wrongAttempts >= 3) {
          Navigator.pushReplacementNamed(context, '/login_signup');
        }
      }
    } else {
      // Save the new pattern
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pattern', selectedTiles.join(','));
      // Navigate to the dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _resetPattern() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pattern'); // Remove the stored pattern
    setState(() {
      selectedTiles.clear(); // Clear the selected tiles
      wrongAttempts = 0; // Reset wrong attempts
      isPatternSet = false; // Allow setting a new pattern
    });
  }
}
