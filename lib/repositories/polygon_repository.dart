import '../models/polygon_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

// Custom exception for the repository
class PolygonRepositoryException implements Exception {
  final String message;
  PolygonRepositoryException(this.message);

  @override
  String toString() => 'PolygonRepositoryException: $message';
}

// PolygonRepository class definition
class PolygonRepository {
  // Simulated in-memory storage for polygons
  final Map<String, Polygon> _polygonStorage = {};

  // Lock for thread-safe operations
  final _lock = Object();

  // Fetch all polygons
  Future<List<Polygon>> fetchPolygons() async {
    try {
      _lock;
      // Return a copy of the stored polygons
      return List.unmodifiable(_polygonStorage.values.toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons: $e');
    }
  }

  // Save a polygon to the repository
  Future<void> savePolygon(Polygon polygon) async {
    try {
      _lock;
      if (polygon == null) {
        throw ArgumentError('Polygon cannot be null');
      }
      
      // Generate a new ID if the polygon does not have one
      final id = polygon.id ?? Uuid().v4();
      _polygonStorage[id] = polygon.copyWith(id: id);

      // Simulate a delay to mimic a real database operation
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw PolygonRepositoryException('Error saving polygon: $e');
    }
  }

  // Fetch a polygon by ID
  Future<Polygon> fetchPolygonById(String id) async {
    try {
      _lock;
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }
      final polygon = _polygonStorage[id];
      if (polygon == null) {
        throw PolygonRepositoryException('Polygon with ID $id not found');
      }
      return polygon;
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygon by ID: $e');
    }
  }

  // Update a polygon
  Future<void> updatePolygon(Polygon updatedPolygon) async {
    try {
      _lock;
      if (updatedPolygon == null || updatedPolygon.id == null || updatedPolygon.id.isEmpty) {
        throw ArgumentError('Updated polygon and ID cannot be null or empty');
      }
      final id = updatedPolygon.id!;
      if (!_polygonStorage.containsKey(id)) {
        throw PolygonRepositoryException('Polygon with ID $id not found');
      }
      _polygonStorage[id] = updatedPolygon;
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw PolygonRepositoryException('Error updating polygon: $e');
    }
  }

  // Delete a polygon by ID
  Future<void> deletePolygon(String id) async {
    try {
      _lock;
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }
      final removed = _polygonStorage.remove(id);
      if (removed == null) {
        throw PolygonRepositoryException('Polygon with ID $id not found');
      }
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw PolygonRepositoryException('Error deleting polygon: $e');
    }
  }

  // Fetch polygons within a bounding box
  Future<List<Polygon>> fetchPolygonsInBoundingBox(LatLng topLeft, LatLng bottomRight) async {
    try {
      _lock;
      if (topLeft == null || bottomRight == null) {
        throw ArgumentError('Bounding box coordinates cannot be null');
      }

      // Validate coordinates
      if (topLeft.latitude < bottomRight.latitude || topLeft.longitude > bottomRight.longitude) {
        throw ArgumentError('Invalid bounding box coordinates');
      }

      return List.unmodifiable(_polygonStorage.values.where((polygon) {
        return polygon.points.any((point) {
          return point.latitude >= bottomRight.latitude &&
                 point.latitude <= topLeft.latitude &&
                 point.longitude >= topLeft.longitude &&
                 point.longitude <= bottomRight.longitude;
        });
      }).toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons in bounding box: $e');
    }
  }

  // Fetch polygons by description keyword
  Future<List<Polygon>> fetchPolygonsByDescription(String keyword) async {
    try {
      _lock;
      if (keyword == null || keyword.isEmpty) {
        throw ArgumentError('Keyword cannot be null or empty');
      }
      return List.unmodifiable(_polygonStorage.values.where((polygon) {
        return polygon.description.contains(keyword);
      }).toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons by description keyword: $e');
    }
  }

  // Fetch polygons by points proximity
  Future<List<Polygon>> fetchPolygonsByProximity(LatLng center, double radius) async {
    try {
      _lock;
      if (center == null) {
        throw ArgumentError('Center cannot be null');
      }
      if (radius <= 0) {
        throw ArgumentError('Radius must be greater than zero');
      }
      
      final Distance distance = Distance();

      return List.unmodifiable(_polygonStorage.values.where((polygon) {
        return polygon.points.any((point) {
          return distance.as(LengthUnit.Meter, center, point) <= radius;
        });
      }).toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons by proximity: $e');
    }
  }

  // Count the number of polygons
  Future<int> countPolygons() async {
    try {
      _lock;
      return _polygonStorage.length;
    } catch (e) {
      throw PolygonRepositoryException('Error counting polygons: $e');
    }
  }

  // Fetch polygons by a specific attribute (e.g., description contains keyword)
  Future<List<Polygon>> fetchPolygonsByAttribute(String attribute, String value) async {
    try {
      _lock;
      if (attribute == null || value == null) {
        throw ArgumentError('Attribute and value cannot be null');
      }

      return List.unmodifiable(_polygonStorage.values.where((polygon) {
        if (attribute == 'description') {
          return polygon.description.contains(value);
        } else {
          throw ArgumentError('Unsupported attribute');
        }
      }).toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons by attribute: $e');
    }
  }

  // Fetch polygons by multiple attributes
  Future<List<Polygon>> fetchPolygonsByAttributes(Map<String, String> attributes) async {
    try {
      _lock;
      if (attributes == null || attributes.isEmpty) {
        throw ArgumentError('Attributes cannot be null or empty');
      }

      return List.unmodifiable(_polygonStorage.values.where((polygon) {
        bool matches = true;
        attributes.forEach((key, value) {
          if (key == 'description') {
            if (!polygon.description.contains(value)) {
              matches = false;
            }
          } else {
            throw ArgumentError('Unsupported attribute');
          }
        });
        return matches;
      }).toList());
    } catch (e) {
      throw PolygonRepositoryException('Error fetching polygons by multiple attributes: $e');
    }
  }
}
