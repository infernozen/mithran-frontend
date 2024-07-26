import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

// Custom exception for the repository
class ImageRepositoryException implements Exception {
  final String message;
  ImageRepositoryException(this.message);

  @override
  String toString() => 'ImageRepositoryException: $message';
}

// ImageRepository class definition
class ImageRepository {
  final String _baseUrl;
  final String _apiKey;

  // Constructor
  ImageRepository(this._baseUrl, this._apiKey);

  // Upload an image and return the URL
  Future<UploadedImage> uploadImage(String filePath) async {
    try {
      final response = await _sendImageUploadRequest(filePath);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UploadedImage.fromJson(data);
      } else {
        throw ImageRepositoryException('Failed to upload image');
      }
    } catch (e) {
      throw ImageRepositoryException('Error uploading image: $e');
    }
  }

  // Private method to send image upload request
  Future<http.Response> _sendImageUploadRequest(String filePath) async {
    final uri = Uri.parse('$_baseUrl/images/upload');
    final headers = {
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      throw ImageRepositoryException('Failed to send image upload request: $e');
    }
  }

  // Fetch uploaded image details by URL
  Future<UploadedImage> fetchImageDetails(String imageUrl) async {
    try {
      final response = await _sendFetchImageDetailsRequest(imageUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UploadedImage.fromJson(data);
      } else {
        throw ImageRepositoryException('Failed to fetch image details');
      }
    } catch (e) {
      throw ImageRepositoryException('Error fetching image details: $e');
    }
  }

  // Private method to send request for image details
  Future<http.Response> _sendFetchImageDetailsRequest(String imageUrl) async {
    final uri = Uri.parse(
        '$_baseUrl/images/details?url=${Uri.encodeComponent(imageUrl)}');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request for image details: $e');
    }
  }

  // Delete an uploaded image by URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final response = await _sendDeleteImageRequest(imageUrl);
      if (response.statusCode != 204) {
        throw ImageRepositoryException('Failed to delete image');
      }
    } catch (e) {
      throw ImageRepositoryException('Error deleting image: $e');
    }
  }

  // Private method to send request to delete an image
  Future<http.Response> _sendDeleteImageRequest(String imageUrl) async {
    final uri = Uri.parse('$_baseUrl/images/delete');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode({'url': imageUrl});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request to delete image: $e');
    }
  }

  // List all uploaded images
  Future<List<UploadedImage>> listImages() async {
    try {
      final response = await _sendListImagesRequest();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> imagesJson = data['images'];
        return imagesJson.map((json) => UploadedImage.fromJson(json)).toList();
      } else {
        throw ImageRepositoryException('Failed to list images');
      }
    } catch (e) {
      throw ImageRepositoryException('Error listing images: $e');
    }
  }

  // Private method to send request to list images
  Future<http.Response> _sendListImagesRequest() async {
    final uri = Uri.parse('$_baseUrl/images');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request to list images: $e');
    }
  }

  // Update image details
  Future<void> updateImage(UploadedImage image) async {
    try {
      final response = await _sendUpdateImageRequest(image);
      if (response.statusCode != 200) {
        throw ImageRepositoryException('Failed to update image');
      }
    } catch (e) {
      throw ImageRepositoryException('Error updating image: $e');
    }
  }

  // Private method to send request to update an image
  Future<http.Response> _sendUpdateImageRequest(UploadedImage image) async {
    final uri = Uri.parse('$_baseUrl/images/update');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode(image.toJson());

    try {
      final response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request to update image: $e');
    }
  }

  // Search images by metadata
  Future<List<UploadedImage>> searchImages(String query) async {
    try {
      final response = await _sendSearchImagesRequest(query);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> imagesJson = data['images'];
        return imagesJson.map((json) => UploadedImage.fromJson(json)).toList();
      } else {
        throw ImageRepositoryException('Failed to search images');
      }
    } catch (e) {
      throw ImageRepositoryException('Error searching images: $e');
    }
  }

  // Private method to send search request
  Future<http.Response> _sendSearchImagesRequest(String query) async {
    final uri = Uri.parse('$_baseUrl/images/search?q=$query');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ImageRepositoryException('Failed to send search request: $e');
    }
  }

  // Fetch image metadata by URL
  Future<Map<String, dynamic>> fetchImageMetadata(String imageUrl) async {
    try {
      final response = await _sendFetchImageMetadataRequest(imageUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw ImageRepositoryException('Failed to fetch image metadata');
      }
    } catch (e) {
      throw ImageRepositoryException('Error fetching image metadata: $e');
    }
  }

  // Private method to send request for image metadata
  Future<http.Response> _sendFetchImageMetadataRequest(String imageUrl) async {
    final uri = Uri.parse(
        '$_baseUrl/images/metadata?url=${Uri.encodeComponent(imageUrl)}');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request for image metadata: $e');
    }
  }

  // Fetch image categories
  Future<List<String>> fetchImageCategories() async {
    try {
      final response = await _sendFetchImageCategoriesRequest();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories']);
      } else {
        throw ImageRepositoryException('Failed to fetch image categories');
      }
    } catch (e) {
      throw ImageRepositoryException('Error fetching image categories: $e');
    }
  }

  // Private method to send request for image categories
  Future<http.Response> _sendFetchImageCategoriesRequest() async {
    final uri = Uri.parse('$_baseUrl/images/categories');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };

    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request for image categories: $e');
    }
  }

  // Fetch image upload status
  Future<String> fetchUploadStatus(String filePath) async {
    try {
      final response = await _sendFetchUploadStatusRequest(filePath);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'];
      } else {
        throw ImageRepositoryException('Failed to fetch upload status');
      }
    } catch (e) {
      throw ImageRepositoryException('Error fetching upload status: $e');
    }
  }

  // Private method to send request for image upload status
  Future<http.Response> _sendFetchUploadStatusRequest(String filePath) async {
    final uri = Uri.parse('$_baseUrl/images/upload/status');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
    };
    final body = json.encode({'filePath': filePath});

    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ImageRepositoryException(
          'Failed to send request for upload status: $e');
    }
  }
}
