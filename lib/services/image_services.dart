import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';
import '../repositories/image_repository.dart';

class ImageService {
  final ImageRepository _imageRepository = ImageRepository();

  // Upload an image
  Future<UploadedImage> uploadImage(String filePath) async {
    try {
      final response = await _imageRepository.uploadImage(filePath);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UploadedImage.fromJson(responseData);
      } else {
        throw HttpException('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Get image details by ID
  Future<UploadedImage> getImageDetails(String imageId) async {
    try {
      final response = await _imageRepository.getImageDetails(imageId);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UploadedImage.fromJson(responseData);
      } else {
        throw HttpException('Failed to fetch image details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching image details: $e');
    }
  }

  // Delete an image by ID
  Future<void> deleteImage(String imageId) async {
    try {
      final response = await _imageRepository.deleteImage(imageId);

      if (response.statusCode != 204) {
        throw HttpException('Failed to delete image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  // Search for images based on criteria
  Future<List<UploadedImage>> searchImages(String query) async {
    try {
      final response = await _imageRepository.searchImages(query);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => UploadedImage.fromJson(data)).toList();
      } else {
        throw HttpException('Failed to search images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching images: $e');
    }
  }

  // List all images
  Future<List<UploadedImage>> getAllImages() async {
    try {
      final response = await _imageRepository.getAllImages();

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => UploadedImage.fromJson(data)).toList();
      } else {
        throw HttpException('Failed to fetch all images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all images: $e');
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
  final Map<String, UploadedImage> _cache = {};

  Future<UploadedImage> getCachedImage(String imageId) async {
    if (_cache.containsKey(imageId)) {
      return _cache[imageId]!;
    } else {
      final image = await getImageDetails(imageId);
      _cache[imageId] = image;
      return image;
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

// Example image model
class UploadedImage {
  final String id;
  final String url;
  final String fileName;

  UploadedImage({required this.id, required this.url, required this.fileName});

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      id: json['id'] as String,
      url: json['url'] as String,
      fileName: json['file_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'file_name': fileName,
  };
}

// Example image repository
class ImageRepository {
  final String baseUrl = 'https://api.example.com/images';

  Future<http.Response> uploadImage(String filePath) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> getImageDetails(String imageId) {
    final url = Uri.parse('$baseUrl/$imageId');
    return http.get(url);
  }

  Future<http.Response> deleteImage(String imageId) {
    final url = Uri.parse('$baseUrl/$imageId');
    return http.delete(url);
  }

  Future<http.Response> searchImages(String query) {
    final url = Uri.parse('$baseUrl/search');
    return http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'query': query}));
  }

  Future<http.Response> getAllImages() {
    final url = Uri.parse('$baseUrl/all');
    return http.get(url);
  }
}
