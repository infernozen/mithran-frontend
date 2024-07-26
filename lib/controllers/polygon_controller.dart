import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Polygon Model
class Polygon {
  final String id;
  final List<List<double>> coordinates;
  final String color;

  Polygon({
    required this.id,
    required this.coordinates,
    required this.color,
  });

  factory Polygon.fromJson(Map<String, dynamic> json) {
    return Polygon(
      id: json['id'],
      coordinates: List<List<double>>.from(
        json['coordinates'].map((coords) => List<double>.from(coords)),
      ),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coordinates': coordinates,
      'color': color,
    };
  }

  @override
  String toString() {
    return 'Polygon(id: $id, coordinates: $coordinates, color: $color)';
  }
}

// Polygon Service
class PolygonService {
  final String _baseUrl = 'https://api.example.com/polygons'; // Replace with your API endpoint

  Future<List<Polygon>> getPolygons() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Polygon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load polygons');
    }
  }

  Future<void> savePolygon(Polygon polygon) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(polygon.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to save polygon');
    }
  }
}

// Polygon Controller
class PolygonController {
  final PolygonService _polygonService = PolygonService();

  Future<List<Polygon>> fetchPolygons() async {
    try {
      return await _polygonService.getPolygons();
    } catch (e) {
      print('Error fetching polygons: $e');
      return [];
    }
  }

  Future<void> savePolygon(Polygon polygon) async {
    try {
      await _polygonService.savePolygon(polygon);
    } catch (e) {
      print('Error saving polygon: $e');
    }
  }
}

// Polygon Helper Functions
Polygon createPolygon(List<List<double>> coordinates, String color) {
  return Polygon(
    id: UniqueKey().toString(),
    coordinates: coordinates,
    color: color,
  );
}

bool validatePolygonCoordinates(List<List<double>> coordinates) {
  return coordinates.length >= 3;
}

String generateRandomColor() {
  final rand = (int n) => (n * 255).toInt();
  return 'rgba(${rand(0.5)},${rand(0.5)},${rand(0.5)},0.5)';
}

List<Map<String, dynamic>> convertPolygonsForDisplay(List<Polygon> polygons) {
  return polygons.map((polygon) => polygon.toJson()).toList();
}

// Polygon Widget
class PolygonWidget extends StatelessWidget {
  final List<Polygon> polygons;

  const PolygonWidget({Key? key, required this.polygons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: polygons.length,
      itemBuilder: (context, index) {
        final polygon = polygons[index];
        return ListTile(
          title: Text('Polygon ID: ${polygon.id}'),
          subtitle: Text('Color: ${polygon.color}'),
          onTap: () {
            _showPolygonDetails(context, polygon);
          },
        );
      },
    );
  }

  void _showPolygonDetails(BuildContext context, Polygon polygon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Polygon Details'),
          content: Text('ID: ${polygon.id}\nColor: ${polygon.color}\nCoordinates: ${polygon.coordinates}'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Polygon Screen
class PolygonScreen extends StatefulWidget {
  @override
  _PolygonScreenState createState() => _PolygonScreenState();
}

class _PolygonScreenState extends State<PolygonScreen> {
  final PolygonController _polygonController = PolygonController();
  late Future<List<Polygon>> _polygonsFuture;

  @override
  void initState() {
    super.initState();
    _polygonsFuture = _polygonController.fetchPolygons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygons'),
      ),
      body: FutureBuilder<List<Polygon>>(
        future: _polygonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No polygons found'));
          } else {
            return PolygonWidget(polygons: snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPolygon,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addPolygon() {
    final newPolygon = Polygon(
      id: UniqueKey().toString(),
      coordinates: [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]],
      color: generateRandomColor(),
    );

    _polygonController.savePolygon(newPolygon).then((_) {
      setState(() {
        _polygonsFuture = _polygonController.fetchPolygons();
      });
    });
  }
}

// Unit Test
void main() {
  group('PolygonController', () {
    test('fetchPolygons returns a list of polygons', () async {
      final controller = PolygonController();
      final polygons = await controller.fetchPolygons();
      expect(polygons, isA<List<Polygon>>());
    });

    test('savePolygon saves a new polygon', () async {
      final controller = PolygonController();
      final polygon = Polygon(
        id: 'test_id',
        coordinates: [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]],
        color: 'blue',
      );
      await controller.savePolygon(polygon);
    });
  });

  group('Polygon Helper Functions', () {
    test('createPolygon creates a polygon with correct attributes', () {
      final coordinates = [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]];
      final color = 'red';
      final polygon = createPolygon(coordinates, color);
      expect(polygon.coordinates, equals(coordinates));
      expect(polygon.color, equals(color));
    });

    test('validatePolygonCoordinates returns true for valid coordinates', () {
      final coordinates = [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]];
      expect(validatePolygonCoordinates(coordinates), isTrue);
    });

    test('generateRandomColor generates a color string', () {
      final color = generateRandomColor();
      expect(color, startsWith('rgba('));
      expect(color, endsWith(')'));
    });
  });
}
