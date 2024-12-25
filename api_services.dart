import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> authenticateUser(String username, String password) async {
    final String url = "https://98ec17b1-56d1-448c-82a2-7f272790507e.mock.pstmn.io/auth/token";

    // Create the request body
    Map<String, String> requestBody = {
      "client_id": "NOBOYNO-Kqh28",
      "client_secret": "-YOURGIR?THENNOTOO-CLJQYteD9c",
      "username": username,
      "password": password,
    };

    // Send the request
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    // Process the response
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Authentication failed. Please try again.'};
    }
  }

  static Future<Map<String, dynamic>> fetchDashboardData(String token) async {
    final String url = "https://98ec17b1-56d1-448c-82a2-7f272790507e.mock.pstmn.io/utility-statements"; // Updated endpoint

    // Send the request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token", // Use the token for authorization
        "Content-Type": "application/json",
      },
    );

    // Process the response
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dashboard data: ${response.statusCode}');
    }
  }
}
