import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      return json.decode(response.body);
    } else {
      print('Response status: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
