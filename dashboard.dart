import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_services.dart'; // Make sure to import your API service file
import 'energy_data.dart'; // Import your data models
import 'package:fl_chart/fl_chart.dart'; // Import the charting library
import 'solartrans.dart'; // Import the SolarTransScreen
import 'package:percent_indicator/percent_indicator.dart'; // Import the percent_indicator package

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String username = ""; // To hold the dynamic username
  bool isLoggedIn = false; // To check if the user is logged in

  // Variables to hold fetched data
  BarChartTile? barChartTile;
  CircleCompletionTile? circleCompletionTile;
  SavingSuggestionsTile? savingSuggestionsTile;
  DueBillTile? dueBillTile;

  // Variable to hold the selected time option
  String selectedTimeOption = '3M'; // Default time option

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if the user is already logged in
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (storedUsername != null && storedPassword != null) {
      // Automatically log in the user if credentials are stored
      await authenticateUser(storedUsername, storedPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101015), // Background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              isLoggedIn ? _buildDashboard() : _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, $username',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFFF1F0E1),
              fontFamily: 'ProtoMono',
            ),
          ),
          _buildGoSolarButton(),
        ],
      ),
    );
  }

  Widget _buildGoSolarButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to SolarTransScreen with animation
        Navigator.of(context).push(_createRoute());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF506385),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Go Solar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Function to create a route with animation
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SolarTransScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End at the center
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFFF1F0E1),
            fontFamily: 'ProtoMono', // Use the same font as in intro slides
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Color(0xFFF1F0E1)),
            border: OutlineInputBorder(),
          ),
          style: TextStyle(color: Color(0xFFF1F0E1)),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Color(0xFFF1F0E1)),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          style: TextStyle(color: Color(0xFFF1F0E1)),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              await authenticateUser(usernameController.text, passwordController.text);
            },
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar Chart Tile
        if (barChartTile != null) _buildBarChartTile(barChartTile!),
        SizedBox(height: 20),
        // Circle Completion Tile
        if (circleCompletionTile != null) _buildCircleCompletionTile(circleCompletionTile!),
        SizedBox(height: 20),
        // Row to hold Current Bill and Go Solar tiles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Current Bill Tile
            if (dueBillTile != null) _buildDueBillTile(dueBillTile!),
            SizedBox(width: 20), // Add some space between the tiles
            // Go Solar Tile
            _buildGoSolarTile(),
          ],
        ),
        SizedBox(height: 20),
        // Saving Suggestions Tile
        if (savingSuggestionsTile != null) _buildSavingSuggestionsTile(savingSuggestionsTile!),
      ],
    );
  }

  Widget _buildBarChartTile(BarChartTile tile) {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tile.title, style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            SizedBox(height: 10),
            // Dropdown for selecting time options
            DropdownButton<String>(
              value: selectedTimeOption,
              dropdownColor: Color(0xFF1E1E1E),
              style: TextStyle(color: Color(0xFFF1F0E1)),
              items: tile.timeOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTimeOption = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: tile.data[selectedTimeOption]!.map((usageData) {
                    return BarChartGroupData(
                      x: tile.data[selectedTimeOption]!.indexOf(usageData),
                      barRods: [
                        BarChartRodData(
                          toY: usageData.usage.toDouble(),
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleCompletionTile(CircleCompletionTile tile) {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tile.title, style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  // Circular Percent Indicator for 45% efficiency
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 8.0,
                    percent: 0.45, // 45% efficiency
                    center: Text(
                      '45%',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                    progressColor: Colors.red,
                    backgroundColor: Colors.grey[300] ?? Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(tile.usageText, style: TextStyle(color: Color(0xFF4CE21A))),
                  Text('Current Usage: ${tile.currentUsage}', style: TextStyle(color: Color(0xFFF1F0E1))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingSuggestionsTile(SavingSuggestionsTile tile) {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tile.title, style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            ...tile.suggestions.map((suggestion) => Text('- $suggestion', style: TextStyle(color: Color(0xFFF1F0E1)))).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDueBillTile(DueBillTile tile) {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tile.title, style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            Text('Amount Due: ${tile.amountDue}', style: TextStyle(color: Color(0xFFF1F0E1))),
            Text('Due Date: ${tile.dueDate}', style: TextStyle(color: Color(0xFFF1F0E1))),
            Text('Status: ${tile.status}', style: TextStyle(color: Color(0xFFF1F0E1))),
          ],
        ),
      ),
    );
  }

  Widget _buildGoSolarTile() {
    return Card(
      color: Color(0xFF628550), // Set the desired color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to SolarTransScreen with animation
                Navigator.of(context).push(_createRoute());
              },
              child: Center(
                child: Text(
                  'Go Solar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to authenticate user
  Future<void> authenticateUser(String username, String password) async {
    // Call the API service to authenticate user
    var response = await ApiService.authenticateUser(username, password);

    print('Response: $response'); // Debugging line

    // Check if the response contains the access_token
    if (response != null && response['access_token'] != null) {
      // Save the username and password in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      // Fetch dashboard data after successful authentication
      await _fetchDashboardData(response['access_token']);

      // Assuming response contains the user information
      setState(() {
        this.username = username; // Set the username for the dashboard
        isLoggedIn = true; // Update login status
      });
    } else {
      // Show error message if authentication fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?['message'] ?? 'Unknown error occurred.')),
      );
    }
  }

  // Function to fetch dashboard data
  Future<void> _fetchDashboardData(String token) async {
    try {
      var response = await ApiService.fetchDashboardData(token);
      print('API Response: $response'); // Log the response for debugging

      // Check if the response contains the 'tiles' key
      if (response['tiles'] != null) {
        var tiles = response['tiles'];

        // Safely parse the data here and update the state
        if (tiles['barChartTile'] != null) {
          barChartTile = BarChartTile.fromJson(tiles['barChartTile']);
        } else {
          print('BarChartTile is null');
        }

        if (tiles['circleCompletionTile'] != null) {
          circleCompletionTile = CircleCompletionTile.fromJson(tiles['circleCompletionTile']);
        } else {
          print('CircleCompletionTile is null');
        }

        if (tiles['savingSuggestionsTile'] != null) {
          savingSuggestionsTile = SavingSuggestionsTile.fromJson(tiles['savingSuggestionsTile']);
        } else {
          print('SavingSuggestionsTile is null');
        }

        if (tiles['dueBillTile'] != null) {
          dueBillTile = DueBillTile.fromJson(tiles['dueBillTile']);
        } else {
          print('DueBillTile is null');
        }

        // Update the state with the parsed data
        setState(() {});
      } else {
        print('Tiles are null in the response');
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch dashboard data.')),
      );
    }
  }
}
