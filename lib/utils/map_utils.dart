import 'package:latlong2/latlong.dart';

class MapUtils {
  /// Calculates the area of a polygon defined by a list of [LatLng] points.
  /// Uses the Shoelace formula to compute the area.
  static double calculatePolygonArea(List<LatLng> points) {
    if (points.isEmpty || points.length < 3) {
      throw ArgumentError('A polygon must have at least 3 points.');
    }

    double area = 0.0;
    int j = points.length - 1;

    for (int i = 0; i < points.length; i++) {
      LatLng point1 = points[j];
      LatLng point2 = points[i];
      area += (point1.latitude * point2.longitude) - (point2.latitude * point1.longitude);
      j = i;
    }

    return (area.abs() / 2.0);
  }

  /// Converts latitude and longitude to Cartesian coordinates (x, y).
  /// This is used for more accurate calculations in some cases.
  static LatLng toCartesian(LatLng point) {
    const double earthRadius = 6378137.0; // Radius of the Earth in meters
    double latRad = point.latitude * (3.141592653589793 / 180.0);
    double lonRad = point.longitude * (3.141592653589793 / 180.0);
    
    double x = earthRadius * lonRad;
    double y = earthRadius * (1 - point.latitude / 90);

    return LatLng(x, y);
  }

  /// Calculates the distance between two [LatLng] points using the Haversine formula.
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371.0; // Earth radius in kilometers

    double lat1 = point1.latitude * (3.141592653589793 / 180.0);
    double lon1 = point1.longitude * (3.141592653589793 / 180.0);
    double lat2 = point2.latitude * (3.141592653589793 / 180.0);
    double lon2 = point2.longitude * (3.141592653589793 / 180.0);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
               (cos(lat1) * cos(lat2) *
               sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
