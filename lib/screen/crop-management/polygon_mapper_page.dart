import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/polygon_controller.dart';
import '../widgets/polygon_mapper_widgets.dart';

class PolygonMapperPage extends StatelessWidget {
  final PolygonController polygonController;

  PolygonMapperPage({Key? key, required this.polygonController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon Mapper'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add functionality to add a new polygon
              // This could open a new screen or show a dialog for user input
            },
          ),
        ],
      ),
      body: PolygonMapperWidget(polygonController: polygonController),
    );
  }
}

class PolygonMapperWidget extends StatefulWidget {
  final PolygonController polygonController;

  PolygonMapperWidget({Key? key, required this.polygonController}) : super(key: key);

  @override
  _PolygonMapperWidgetState createState() => _PolygonMapperWidgetState();
}

class _PolygonMapperWidgetState extends State<PolygonMapperWidget> {
  late Future<List<Polygon>> _polygonsFuture;

  @override
  void initState() {
    super.initState();
    _polygonsFuture = widget.polygonController.fetchPolygons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Polygon>>(
      future: _polygonsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final polygons = snapshot.data!;
          return FlutterMap(
            options: MapOptions(
              center: LatLng(51.509, -0.09),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolygonLayerOptions(
                polygons: polygons.map((polygon) => Polygon(
                  points: polygon.points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
                  color: Colors.blue.withOpacity(0.3),
                  borderStrokeWidth: 3.0,
                  borderColor: Colors.blue,
                )).toList(),
              ),
            ],
          );
        } else {
          return Center(child: Text('No polygons available'));
        }
      },
    );
  }
}
