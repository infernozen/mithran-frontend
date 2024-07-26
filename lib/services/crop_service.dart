import '../models/crop_model.dart';
import '../repositories/crop_repository.dart';

class CropService {
  final CropRepository _cropRepository = CropRepository();

  // Cache for storing fetched crops
  final Map<String, List<Crop>> _cache = {};

  // Fetches crops from the repository and handles caching
  Future<List<Crop>> getCrops({bool forceRefresh = false}) async {
    final cacheKey = 'crops';

    // Check if data is in the cache and refresh is not forced
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      // Fetch data from the repository
      final crops = await _cropRepository.fetchCrops();

      // Update the cache
      _cache[cacheKey] = crops;

      return crops;
    } catch (e) {
      // Handle errors appropriately
      throw Exception('Error fetching crops: $e');
    }
  }

  // Fetch crop details by ID
  Future<Crop> getCropDetails(String cropId) async {
    try {
      final crop = await _cropRepository.fetchCropById(cropId);
      return crop;
    } catch (e) {
      throw Exception('Error fetching crop details: $e');
    }
  }

  // Search for crops based on criteria
  Future<List<Crop>> searchCrops(String query) async {
    try {
      final crops = await _cropRepository.searchCrops(query);
      return crops;
    } catch (e) {
      throw Exception('Error searching crops: $e');
    }
  }

  // Add a new crop
  Future<void> addCrop(Crop newCrop) async {
    try {
      await _cropRepository.addCrop(newCrop);
      // Invalidate cache
      _cache.clear();
    } catch (e) {
      throw Exception('Error adding crop: $e');
    }
  }

  // Update an existing crop
  Future<void> updateCrop(Crop updatedCrop) async {
    try {
      await _cropRepository.updateCrop(updatedCrop);
      // Invalidate cache
      _cache.clear();
    } catch (e) {
      throw Exception('Error updating crop: $e');
    }
  }

  // Delete a crop by ID
  Future<void> deleteCrop(String cropId) async {
    try {
      await _cropRepository.deleteCrop(cropId);
      // Invalidate cache
      _cache.clear();
    } catch (e) {
      throw Exception('Error deleting crop: $e');
    }
  }

  // Utility method to handle HTTP errors
  void handleHttpError(Exception e) {
    // Implement error handling, e.g., logging or user notifications
    print('HTTP Error: $e');
  }

  // Logging for requests and responses
  void logRequest(String method, String endpoint, {Map<String, dynamic>? data}) {
    print('Request Method: $method');
    print('Request Endpoint: $endpoint');
    if (data != null) {
      print('Request Data: ${data}');
    }
  }

  void logResponse(int statusCode, String responseBody) {
    print('Response Status Code: $statusCode');
    print('Response Body: $responseBody');
  }
}

// Example CropRepository class
class CropRepository {
  final String baseUrl = 'https://api.example.com/crops';

  // Fetch all crops
  Future<List<Crop>> fetchCrops() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => Crop.fromJson(data)).toList();
    } else {
      throw HttpException('Failed to fetch crops: ${response.statusCode}');
    }
  }

  // Fetch a crop by ID
  Future<Crop> fetchCropById(String cropId) async {
    final url = Uri.parse('$baseUrl/$cropId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Crop.fromJson(responseData);
    } else {
      throw HttpException('Failed to fetch crop details: ${response.statusCode}');
    }
  }

  // Search for crops based on a query
  Future<List<Crop>> searchCrops(String query) async {
    final url = Uri.parse('$baseUrl/search');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => Crop.fromJson(data)).toList();
    } else {
      throw HttpException('Failed to search crops: ${response.statusCode}');
    }
  }

  // Add a new crop
  Future<void> addCrop(Crop newCrop) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newCrop.toJson()),
    );
    if (response.statusCode != 201) {
      throw HttpException('Failed to add crop: ${response.statusCode}');
    }
  }

  // Update an existing crop
  Future<void> updateCrop(Crop updatedCrop) async {
    final url = Uri.parse('$baseUrl/${updatedCrop.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedCrop.toJson()),
    );
    if (response.statusCode != 200) {
      throw HttpException('Failed to update crop: ${response.statusCode}');
    }
  }

  // Delete a crop by ID
  Future<void> deleteCrop(String cropId) async {
    final url = Uri.parse('$baseUrl/$cropId');
    final response = await http.delete(url);
    if (response.statusCode != 204) {
      throw HttpException('Failed to delete crop: ${response.statusCode}');
    }
  }
}
