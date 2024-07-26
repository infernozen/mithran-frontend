import 'package:latlong2/latlong.dart';

class Polygon {
  final String id;
  final List<LatLng> points;
  final String description;

  Polygon({
    required this.id,
    required this.points,
    required this.description,
  });
}
