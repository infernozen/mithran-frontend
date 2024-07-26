// old code given by rohith
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart'; // Import the Flutter Map package
// import 'package:latlong2/latlong.dart'; // Import the latlong2 package

// const kMarker = "https://www.sccpre.cat/png/big/16/164026_map-marker-png.png";

// class MapScreen extends StatefulWidget {
//   MapScreen({Key? key}) : super(key: key);

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   List<LatLng> _touches = [];
//   List<Polygon> _polygons = [];

//   void _addMarker(LatLng pos) {
//     setState(() => _touches.add(pos));
//   }

//   Polygon _buildPolygonFromTouches() {
//     return Polygon(
//       points: _touches,
//       borderColor: Colors.black,
//       borderStrokeWidth: 3.0,
//       color: Colors.black26,
//       isFilled: true,
//     );
//   }

//   void _onMarkerTap(LatLng pos, bool isFirst) {
//     if (!isFirst) return;
//     _touches.add(pos);
//     _polygons.add(_buildPolygonFromTouches());
//     _touches.clear();
//     setState(() {}); // Force rebuild
//   }

//   List<Marker> _buildMarkers() {
//     List<Marker> markers = [];
//     for (var i = 0; i < _touches.length; i++) {
//       final pos = _touches[i];
//       markers.add(Marker(
//         width: 30.0,
//         height: 30.0,
//         point: pos,
//         child:GestureDetector(
//           onTap: () => _onMarkerTap(pos, i == 0),
//           onLongPress: () => setState(() => _touches.removeAt(i)),
//           child: Image.network(kMarker),
//         ),
//       ));
//     }
//     return markers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FlutterMap(
//       options: MapOptions(
//         center: LatLng(51.5, -0.09),
//         zoom: 13.0,
//         onTap: _addMarker,
//       ),
//       layers: [
//         TileLayerOptions(
//           urlTemplate: "https://api.tiles.mapbox.com/v4/"
//               "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
//           additionalOptions: {
//             'accessToken':
//                 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
//             'id': 'mapbox.streets',
//           },
//         ),
//         PolygonLayerOptions(polygons: _polygons),
//         MarkerLayerOptions(markers: _buildMarkers()),
//       ],
//       children: [],
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'Flutter Map Example',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: MapScreen(),
//   ));
// }

// new code
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart'; // Import the Flutter Map package
// import 'package:latlong2/latlong.dart'; // Import the latlong2 package

// const kMarker = "https://www.sccpre.cat/png/big/16/164026_map-marker-png.png";

// class MapScreen extends StatefulWidget {
//   MapScreen({Key? key}) : super(key: key);

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   List<LatLng> _touches = [];
//   List<Polygon> _polygons = [];

//   void _addMarker(LatLng pos) {
//     setState(() => _touches.add(pos));
//   }

//   Polygon _buildPolygonFromTouches() {
//     return Polygon(
//       points: _touches,
//       borderColor: Colors.black,
//       borderStrokeWidth: 3.0,
//       color: Colors.black26,
//       isFilled: true,
//     );
//   }

//   void _onMarkerTap(LatLng pos, bool isFirst) {
//     if (!isFirst) return;
//     _touches.add(pos);
//     _polygons.add(_buildPolygonFromTouches());
//     _touches.clear();
//     setState(() {}); // Force rebuild
//   }

//   List<Marker> _buildMarkers() {
//     List<Marker> markers = [];
//     for (var i = 0; i < _touches.length; i++) {
//       final pos = _touches[i];
//       markers.add(Marker(
//         width: 30.0,
//         height: 30.0,
//         point: pos,
//         builder: (ctx) => GestureDetector(
//           onTap: () => _onMarkerTap(pos, i == 0),
//           onLongPress: () => setState(() => _touches.removeAt(i)),
//           child: Image.network(kMarker),
//         ),
//       ));
//     }
//     return markers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           center: LatLng(51.5, -0.09),
//           zoom: 13.0,
//           onTap: (pos) => _addMarker(pos),
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate: "https://api.tiles.mapbox.com/v4/"
//                 "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
//             additionalOptions: {
//               'accessToken':
//                   'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
//               'id': 'mapbox.streets',
//             },
//           ),
//           PolygonLayerOptions(polygons: _polygons),
//           MarkerLayerOptions(markers: _buildMarkers()),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'Flutter Map Example',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: MapScreen(),
//   ));
// }
