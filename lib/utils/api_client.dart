import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  final Map<String, String>? headers;

  ApiClient({
    required this.baseUrl,
    this.headers,
  });

  // POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      _checkResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      _checkResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  // PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      _checkResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to put data: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(String endpoint,
      {Map<String, dynamic>? data}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.delete(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      _checkResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  // Check if the response is successful
  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed request with status: ${response.statusCode}');
    }
  }
}
