import '../models/polygon_model.dart';
import '../repositories/polygon_repository.dart';

class PolygonService {
  final PolygonRepository _polygonRepository = PolygonRepository();

  // Cache for storing fetched polygons
  final Map<String, List<Polygon>> _cache = {};

  // Fetch all polygons from the repository with optional caching
  Future<List<Polygon>> getPolygons({bool forceRefresh = false}) async {
    final cacheKey = 'polygons';

    // Return cached data if available and refresh is not forced
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final polygons = await _polygonRepository.fetchPolygons();

      // Update the cache
      _cache[cacheKey] = polygons;

      return polygons;
    } catch (e) {
      // Handle errors appropriately
      throw Exception('Error fetching polygons: $e');
    }
  }

  // Save a new or updated polygon
  Future<void> savePolygon(Polygon polygon) async {
    try {
      await _polygonRepository.savePolygon(polygon);

      // Invalidate cache after saving
      _cache.clear();
    } catch (e) {
      throw Exception('Error saving polygon: $e');
    }
  }

  // Delete a polygon by ID
  Future<void> deletePolygon(String polygonId) async {
    try {
      await _polygonRepository.deletePolygon(polygonId);

      // Invalidate cache after deletion
      _cache.clear();
    } catch (e) {
      throw Exception('Error deleting polygon: $e');
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

// Example PolygonRepository class
class PolygonRepository {
  final String baseUrl = 'https://api.example.com/polygons';

  // Fetch all polygons
  Future<List<Polygon>> fetchPolygons() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => Polygon.fromJson(data)).toList();
    } else {
      throw HttpException('Failed to fetch polygons: ${response.statusCode}');
    }
  }

  // Save a new or updated polygon
  Future<void> savePolygon(Polygon polygon) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(polygon.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw HttpException('Failed to save polygon: ${response.statusCode}');
    }
  }

  // Delete a polygon by ID
  Future<void> deletePolygon(String polygonId) async {
    final url = Uri.parse('$baseUrl/$polygonId');
    final response = await http.delete(url);
    if (response.statusCode != 204) {
      throw HttpException('Failed to delete polygon: ${response.statusCode}');
    }
  }
}
