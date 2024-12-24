import 'package:flutter/material.dart';
import 'energy_data.dart'; // Import your data models
import 'package:fl_chart/fl_chart.dart'; // Import the charting library
import 'package:percent_indicator/percent_indicator.dart'; // Ensure this import is present

class SolarTransScreen extends StatefulWidget {
  @override
  _SolarTransScreenState createState() => _SolarTransScreenState();
}

class _SolarTransScreenState extends State<SolarTransScreen> {
  // Sample data for demonstration
  final BarChartTile barChartTile = BarChartTile(
    title: 'Energy Usage (kWh)',
    timeOptions: ['3M', '6M', '9M'],
    selectedTime: '3M',
    data: {
      '3M': [
        UsageData(month: 'August 2024', usage: 380),
        UsageData(month: 'September 2024', usage: 400),
        UsageData(month: 'October 2024', usage: 350),
      ],
      '6M': [
        UsageData(month: 'May 2024', usage: 450),
        UsageData(month: 'June 2024', usage: 430),
        UsageData(month: 'July 2024', usage: 410),
        UsageData(month: 'August 2024', usage: 380),
        UsageData(month: 'September 2024', usage: 400),
        UsageData(month: 'October 2024', usage: 350),
      ],
      '9M': [
        UsageData(month: 'February 2024', usage: 470),
        UsageData(month: 'March 2024', usage: 460),
        UsageData(month: 'April 2024', usage: 440),
        UsageData(month: 'May 2024', usage: 450),
        UsageData(month: 'June 2024', usage: 430),
        UsageData(month: 'July 2024', usage: 410),
        UsageData(month: 'August 2024', usage: 380),
        UsageData(month: 'September 2024', usage: 400),
        UsageData(month: 'October 2024', usage: 350),
      ],
    },
  );

  String selectedTimeOption = '3M'; // Default time option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101015),
      appBar: AppBar(
        title: Text('Solar Transition'),
        backgroundColor: Color(0xFF506385),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solar Information',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFF1F0E1),
                  fontFamily: 'ProtoMono',
                ),
              ),
              SizedBox(height: 20),
              _buildTimeOptionsDropdown(),
              SizedBox(height: 20),
              _buildBarChartTile(barChartTile),
              SizedBox(height: 20),
              _buildCircleCompletionTile(),
              SizedBox(height: 20),
              _buildCurrentBillTile(120.50), // Example amount due
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeOptionsDropdown() {
    return DropdownButton<String>(
      value: selectedTimeOption,
      dropdownColor: Color(0xFF1E1E1E),
      style: TextStyle(color: Color(0xFFF1F0E1)),
      items: barChartTile.timeOptions.map<DropdownMenuItem<String>>((String value) {
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
                          color: Colors.orange.withOpacity(0.4), // 40% orange
                          width: 20,
                        ),
                        BarChartRodData(
                          toY: usageData.usage.toDouble() * 0.6, // 60% normal
                          color: Colors.blue, // Normal color
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

  Widget _buildCircleCompletionTile() {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Efficiency', style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  // Circular Percent Indicator for 80% efficiency
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 8.0,
                    percent: 0.80, // 80% efficiency
                    center: Text(
                      '80%',
                      style: TextStyle(fontSize: 24, color: Color(0xFFF1F0E1)),
                    ),
                    progressColor: Color(0xFF4CE21A), // Change color as needed
                    backgroundColor: Colors.grey[300] ?? Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text('Solar Usage: 140 kWh', style: TextStyle(color: Color(0xFFF1F0E1))),
                  Text('Total Usage: 350 kWh', style: TextStyle(color: Color(0xFFF1F0E1))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBillTile(double amountDue) {
    double discountedAmount = amountDue * 0.6; // 40% discount
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Bill', style: TextStyle(fontSize: 18, color: Color(0xFFF1F0E1), fontFamily: 'ProtoMono')),
            SizedBox(height: 10),
            Text('Amount Due: \$${amountDue.toStringAsFixed(2)}', style: TextStyle(color: Color(0xFFF1F0E1))),
            Text('Discounted Amount: \$${discountedAmount.toStringAsFixed(2)}', style: TextStyle(color: Color(0xFFF1F0E1))),
          ],
        ),
      ),
    );
  }
}
