import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/crop_model.dart';

// Define a custom exception for handling errors
class CropRepositoryException implements Exception {
  final String message;
  CropRepositoryException(this.message);

  @override
  String toString() => 'CropRepositoryException: $message';
}

// Define the CropRepository class
class CropRepository {
  final String _baseUrl;
  final String _apiKey;

  // Constructor
  CropRepository(this._baseUrl, this._apiKey);

  // Fetch crops from the API with pagination
  Future<List<Crop>> fetchCrops({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _sendRequest(page, pageSize);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cropsJson = data['crops'];
        return cropsJson.map((json) => Crop.fromJson(json)).toList();
      } else {
        throw CropRepositoryException('Failed to fetch crops from API');
      }
    } catch (e) {
      throw CropRepositoryException('Error fetching crops: $e');
    }
  }

  // Private method to send a paginated request to the API
  Future<http.Response> _sendRequest(int page, int pageSize) async {
    final uri = Uri.parse('$_baseUrl/crops?page=$page&pageSize=$pageSize');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request: $e');
    }
  }

  // Fetch a single crop by ID
  Future<Crop> fetchCropById(String id) async {
    try {
      final response = await _sendCropByIdRequest(id);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Crop.fromJson(data);
      } else {
        throw CropRepositoryException('Failed to fetch crop by ID');
      }
    } catch (e) {
      throw CropRepositoryException('Error fetching crop by ID: $e');
    }
  }

  // Private method to send a request for a single crop by ID
  Future<http.Response> _sendCropByIdRequest(String id) async {
    final uri = Uri.parse('$_baseUrl/crops/$id');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request for crop by ID: $e');
    }
  }

  // Add a new crop
  Future<void> addCrop(Crop crop) async {
    try {
      final response = await _sendAddCropRequest(crop);
      if (response.statusCode != 201) {
        throw CropRepositoryException('Failed to add new crop');
      }
    } catch (e) {
      throw CropRepositoryException('Error adding new crop: $e');
    }
  }

  // Private method to send a request to add a new crop
  Future<http.Response> _sendAddCropRequest(Crop crop) async {
    final uri = Uri.parse('$_baseUrl/crops');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode(crop.toJson());

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request to add crop: $e');
    }
  }

  // Update an existing crop
  Future<void> updateCrop(Crop crop) async {
    try {
      final response = await _sendUpdateCropRequest(crop);
      if (response.statusCode != 200) {
        throw CropRepositoryException('Failed to update crop');
      }
    } catch (e) {
      throw CropRepositoryException('Error updating crop: $e');
    }
  }

  // Private method to send a request to update a crop
  Future<http.Response> _sendUpdateCropRequest(Crop crop) async {
    final uri = Uri.parse('$_baseUrl/crops/${crop.id}');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode(crop.toJson());

    try {
      final response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request to update crop: $e');
    }
  }

  // Delete a crop by ID
  Future<void> deleteCrop(String id) async {
    try {
      final response = await _sendDeleteCropRequest(id);
      if (response.statusCode != 204) {
        throw CropRepositoryException('Failed to delete crop');
      }
    } catch (e) {
      throw CropRepositoryException('Error deleting crop: $e');
    }
  }

  // Private method to send a request to delete a crop
  Future<http.Response> _sendDeleteCropRequest(String id) async {
    final uri = Uri.parse('$_baseUrl/crops/$id');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.delete(uri, headers: headers);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request to delete crop: $e');
    }
  }

  // Search crops by name or description
  Future<List<Crop>> searchCrops(String query) async {
    try {
      final response = await _sendSearchRequest(query);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cropsJson = data['crops'];
        return cropsJson.map((json) => Crop.fromJson(json)).toList();
      } else {
        throw CropRepositoryException('Failed to search crops');
      }
    } catch (e) {
      throw CropRepositoryException('Error searching crops: $e');
    }
  }

  // Private method to send a search request to the API
  Future<http.Response> _sendSearchRequest(String query) async {
    final uri = Uri.parse('$_baseUrl/crops/search?q=$query');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send search request: $e');
    }
  }

  // Fetch crop categories
  Future<List<String>> fetchCropCategories() async {
    try {
      final response = await _sendFetchCategoriesRequest();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories']);
      } else {
        throw CropRepositoryException('Failed to fetch crop categories');
      }
    } catch (e) {
      throw CropRepositoryException('Error fetching crop categories: $e');
    }
  }

  // Private method to send a request to fetch crop categories
  Future<http.Response> _sendFetchCategoriesRequest() async {
    final uri = Uri.parse('$_baseUrl/crops/categories');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw CropRepositoryException('Failed to send request to fetch categories: $e');
    }
  }

  // Handle image upload for crops
  Future<String> uploadCropImage(String cropId, File imageFile) async {
    try {
      final response = await _sendImageUploadRequest(cropId, imageFile);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['imageUrl'];
      } else {
        throw CropRepositoryException('Failed to upload crop image');
      }
    } catch (e) {
      throw CropRepositoryException('Error uploading crop image: $e');
    }
  }

  // Private method to send a request for image upload
  Future<http.Response> _sendImageUploadRequest(String cropId, File imageFile) async {
    final uri = Uri.parse('$_baseUrl/crops/$cropId/image');
    final request = http.MultipartRequest('POST', uri)
      ..headers[HttpHeaders.authorizationHeader] = 'Bearer $_apiKey'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      throw CropRepositoryException('Failed to send image upload request: $e');
    }
  }
}
