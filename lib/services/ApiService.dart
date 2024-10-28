// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> fetchHelpLocations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/centers'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (error) {
      print('Error fetching locations: $error');
      throw error; // Rethrow to handle it in the calling method
    }
  }
}
