import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/disease_model.dart';
import '../repositories/disease_repository.dart';

class DiseaseService {
  final DiseaseRepository _diseaseRepository = DiseaseRepository();

  // Analyze image for disease
  Future<Disease> analyzeImage(String imageUrl) async {
    try {
      final response = await _diseaseRepository.analyzeImage(imageUrl);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Disease.fromJson(responseData);
      } else {
        throw HttpException('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }

  // Fetch disease details by ID
  Future<Disease> getDiseaseDetails(String diseaseId) async {
    try {
      final response = await _diseaseRepository.getDiseaseDetails(diseaseId);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Disease.fromJson(responseData);
      } else {
        throw HttpException('Failed to fetch disease details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching disease details: $e');
    }
  }

  // Search for diseases by name
  Future<List<Disease>> searchDiseases(String query) async {
    try {
      final response = await _diseaseRepository.searchDiseases(query);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => Disease.fromJson(data)).toList();
      } else {
        throw HttpException('Failed to search diseases: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching for diseases: $e');
    }
  }

  // Fetch all diseases
  Future<List<Disease>> getAllDiseases() async {
    try {
      final response = await _diseaseRepository.getAllDiseases();

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => Disease.fromJson(data)).toList();
      } else {
        throw HttpException('Failed to fetch all diseases: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all diseases: $e');
    }
  }

  // Add a new disease
  Future<Disease> addDisease(Disease disease) async {
    try {
      final response = await _diseaseRepository.addDisease(disease);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Disease.fromJson(responseData);
      } else {
        throw HttpException('Failed to add disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding disease: $e');
    }
  }

  // Update an existing disease
  Future<Disease> updateDisease(String diseaseId, Disease disease) async {
    try {
      final response = await _diseaseRepository.updateDisease(diseaseId, disease);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Disease.fromJson(responseData);
      } else {
        throw HttpException('Failed to update disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating disease: $e');
    }
  }

  // Delete a disease by ID
  Future<void> deleteDisease(String diseaseId) async {
    try {
      final response = await _diseaseRepository.deleteDisease(diseaseId);

      if (response.statusCode != 204) {
        throw HttpException('Failed to delete disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting disease: $e');
    }
  }

  // Utility method for handling HTTP responses
  void handleHttpError(http.Response response) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Client error: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  // Cache management (example implementation)
  final Map<String, Disease> _cache = {};

  Future<Disease> getCachedDisease(String diseaseId) async {
    if (_cache.containsKey(diseaseId)) {
      return _cache[diseaseId]!;
    } else {
      final disease = await getDiseaseDetails(diseaseId);
      _cache[diseaseId] = disease;
      return disease;
    }
  }

  // Logging (example implementation)
  void logRequest(String method, String url, {Map<String, dynamic>? data}) {
    print('Request: $method $url');
    if (data != null) {
      print('Data: ${jsonEncode(data)}');
    }
  }

  void logResponse(http.Response response) {
    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');
  }
}

// Example disease model
class Disease {
  final String id;
  final String name;
  final String description;

  Disease({required this.id, required this.name, required this.description});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}

// Example disease repository
class DiseaseRepository {
  final String baseUrl = 'https://api.example.com/diseases';

  Future<http.Response> analyzeImage(String imageUrl) {
    final url = Uri.parse('$baseUrl/analyze');
    return http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'image_url': imageUrl}));
  }

  Future<http.Response> getDiseaseDetails(String diseaseId) {
    final url = Uri.parse('$baseUrl/$diseaseId');
    return http.get(url);
  }

  Future<http.Response> searchDiseases(String query) {
    final url = Uri.parse('$baseUrl/search');
    return http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'query': query}));
  }

  Future<http.Response> getAllDiseases() {
    final url = Uri.parse('$baseUrl/all');
    return http.get(url);
  }

  Future<http.Response> addDisease(Disease disease) {
    final url = Uri.parse('$baseUrl');
    return http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(disease.toJson()));
  }

  Future<http.Response> updateDisease(String diseaseId, Disease disease) {
    final url = Uri.parse('$baseUrl/$diseaseId');
    return http.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(disease.toJson()));
  }

  Future<http.Response> deleteDisease(String diseaseId) {
    final url = Uri.parse('$baseUrl/$diseaseId');
    return http.delete(url);
  }
}
