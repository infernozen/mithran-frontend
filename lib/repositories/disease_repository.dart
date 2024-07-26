import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/disease_model.dart';

// Custom exception for the repository
class DiseaseRepositoryException implements Exception {
  final String message;
  DiseaseRepositoryException(this.message);

  @override
  String toString() => 'DiseaseRepositoryException: $message';
}

// DiseaseRepository class definition
class DiseaseRepository {
  final String _baseUrl;
  final String _apiKey;

  // Constructor
  DiseaseRepository(this._baseUrl, this._apiKey);

  // Analyze an image and return disease information
  Future<Disease> analyzeImage(String imageUrl) async {
    try {
      final response = await _sendAnalysisRequest(imageUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Disease.fromJson(data);
      } else {
        throw DiseaseRepositoryException('Failed to analyze image');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error analyzing image: $e');
    }
  }

  // Private method to send analysis request
  Future<http.Response> _sendAnalysisRequest(String imageUrl) async {
    final uri = Uri.parse('$_baseUrl/diseases/analyze');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode({'imageUrl': imageUrl});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send analysis request: $e');
    }
  }

  // Fetch a list of all diseases
  Future<List<Disease>> fetchAllDiseases() async {
    try {
      final response = await _sendFetchAllDiseasesRequest();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> diseasesJson = data['diseases'];
        return diseasesJson.map((json) => Disease.fromJson(json)).toList();
      } else {
        throw DiseaseRepositoryException('Failed to fetch all diseases');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error fetching all diseases: $e');
    }
  }

  // Private method to send request for fetching all diseases
  Future<http.Response> _sendFetchAllDiseasesRequest() async {
    final uri = Uri.parse('$_baseUrl/diseases');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request for all diseases: $e');
    }
  }

  // Fetch a disease by its ID
  Future<Disease> fetchDiseaseById(String id) async {
    try {
      final response = await _sendFetchDiseaseByIdRequest(id);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Disease.fromJson(data);
      } else {
        throw DiseaseRepositoryException('Failed to fetch disease by ID');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error fetching disease by ID: $e');
    }
  }

  // Private method to send request for fetching a disease by ID
  Future<http.Response> _sendFetchDiseaseByIdRequest(String id) async {
    final uri = Uri.parse('$_baseUrl/diseases/$id');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request for disease by ID: $e');
    }
  }

  // Add a new disease
  Future<void> addDisease(Disease disease) async {
    try {
      final response = await _sendAddDiseaseRequest(disease);
      if (response.statusCode != 201) {
        throw DiseaseRepositoryException('Failed to add new disease');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error adding new disease: $e');
    }
  }

  // Private method to send request to add a new disease
  Future<http.Response> _sendAddDiseaseRequest(Disease disease) async {
    final uri = Uri.parse('$_baseUrl/diseases');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode(disease.toJson());

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request to add disease: $e');
    }
  }

  // Update an existing disease
  Future<void> updateDisease(Disease disease) async {
    try {
      final response = await _sendUpdateDiseaseRequest(disease);
      if (response.statusCode != 200) {
        throw DiseaseRepositoryException('Failed to update disease');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error updating disease: $e');
    }
  }

  // Private method to send request to update a disease
  Future<http.Response> _sendUpdateDiseaseRequest(Disease disease) async {
    final uri = Uri.parse('$_baseUrl/diseases/${disease.id}');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode(disease.toJson());

    try {
      final response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request to update disease: $e');
    }
  }

  // Delete a disease by ID
  Future<void> deleteDisease(String id) async {
    try {
      final response = await _sendDeleteDiseaseRequest(id);
      if (response.statusCode != 204) {
        throw DiseaseRepositoryException('Failed to delete disease');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error deleting disease: $e');
    }
  }

  // Private method to send request to delete a disease
  Future<http.Response> _sendDeleteDiseaseRequest(String id) async {
    final uri = Uri.parse('$_baseUrl/diseases/$id');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.delete(uri, headers: headers);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request to delete disease: $e');
    }
  }

  // Search diseases by name or description
  Future<List<Disease>> searchDiseases(String query) async {
    try {
      final response = await _sendSearchRequest(query);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> diseasesJson = data['diseases'];
        return diseasesJson.map((json) => Disease.fromJson(json)).toList();
      } else {
        throw DiseaseRepositoryException('Failed to search diseases');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error searching diseases: $e');
    }
  }

  // Private method to send search request
  Future<http.Response> _sendSearchRequest(String query) async {
    final uri = Uri.parse('$_baseUrl/diseases/search?q=$query');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send search request: $e');
    }
  }

  // Fetch disease categories
  Future<List<String>> fetchDiseaseCategories() async {
    try {
      final response = await _sendFetchCategoriesRequest();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories']);
      } else {
        throw DiseaseRepositoryException('Failed to fetch disease categories');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error fetching disease categories: $e');
    }
  }

  // Private method to send request for disease categories
  Future<http.Response> _sendFetchCategoriesRequest() async {
    final uri = Uri.parse('$_baseUrl/diseases/categories');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send request to fetch categories: $e');
    }
  }

  // Handle image upload for disease analysis
  Future<void> uploadDiseaseImage(String filePath) async {
    try {
      final response = await _sendImageUploadRequest(filePath);
      if (response.statusCode != 200) {
        throw DiseaseRepositoryException('Failed to upload disease image');
      }
    } catch (e) {
      throw DiseaseRepositoryException('Error uploading disease image: $e');
    }
  }

  // Private method to send image upload request
  Future<http.Response> _sendImageUploadRequest(String filePath) async {
    final uri = Uri.parse('$_baseUrl/diseases/upload');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      throw DiseaseRepositoryException('Failed to send image upload request: $e');
    }
  }
}
