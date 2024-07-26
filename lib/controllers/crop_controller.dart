import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// Crop Model
class Crop {
  final int id;
  final String name;
  final String type;
  final String season;
  final String description;

  Crop({
    required this.id,
    required this.name,
    required this.type,
    required this.season,
    required this.description,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      season: json['season'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'season': season,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Crop(id: $id, name: $name, type: $type, season: $season, description: $description)';
  }
}

// Crop Service
class CropService {
  final String _apiUrl = 'https://api.example.com/crops'; // Replace with your API endpoint

  Future<List<Crop>> getCrops() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Crop.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      throw Exception('Error fetching crops: $e');
    }
  }

  Future<void> addCrop(Crop crop) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(crop.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add crop');
      }
    } catch (e) {
      throw Exception('Error adding crop: $e');
    }
  }

  Future<void> updateCrop(Crop crop) async {
    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/${crop.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(crop.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update crop');
      }
    } catch (e) {
      throw Exception('Error updating crop: $e');
    }
  }

  Future<void> deleteCrop(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_apiUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete crop');
      }
    } catch (e) {
      throw Exception('Error deleting crop: $e');
    }
  }
}

// Crop Controller
class CropController {
  final CropService _cropService;

  CropController(this._cropService);

  Future<List<Crop>> fetchCrops() async {
    return await _cropService.getCrops();
  }

  Future<void> addCrop(Crop crop) async {
    await _cropService.addCrop(crop);
  }

  Future<void> updateCrop(Crop crop) async {
    await _cropService.updateCrop(crop);
  }

  Future<void> deleteCrop(int id) async {
    await _cropService.deleteCrop(id);
  }
}

// Crop List Screen
class CropListScreen extends StatefulWidget {
  @override
  _CropListScreenState createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
  late CropController _cropController;
  ValueNotifier<List<Crop>> _crops = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _cropController = CropController(CropService());
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    try {
      final crops = await _cropController.fetchCrops();
      _crops.value = crops;
    } catch (e) {
      // Handle error
      print('Error loading crops: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crops'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Crop>>(
              valueListenable: _crops,
              builder: (context, crops, child) {
                return ListView.builder(
                  itemCount: crops.length,
                  itemBuilder: (context, index) {
                    final crop = crops[index];
                    return ListTile(
                      title: Text(crop.name),
                      subtitle: Text(crop.type),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteCrop(crop.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _navigateToAddCropScreen,
              child: Text('Add Crop'),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCrop(int id) async {
    try {
      await _cropController.deleteCrop(id);
      _loadCrops();
    } catch (e) {
      // Handle error
      print('Error deleting crop: $e');
    }
  }

  void _navigateToAddCropScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCropScreen(onCropAdded: _loadCrops)),
    );
  }
}

// Add Crop Screen
class AddCropScreen extends StatefulWidget {
  final VoidCallback onCropAdded;

  AddCropScreen({required this.onCropAdded});

  @override
  _AddCropScreenState createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _seasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  final CropController _cropController = CropController(CropService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _seasonController,
              decoration: InputDecoration(labelText: 'Season'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCrop,
              child: Text('Add Crop'),
            ),
          ],
        ),
      ),
    );
  }

  void _addCrop() async {
    final crop = Crop(
      id: 0, // This will be managed by the server
      name: _nameController.text,
      type: _typeController.text,
      season: _seasonController.text,
      description: _descriptionController.text,
    );

    try {
      await _cropController.addCrop(crop);
      widget.onCropAdded();
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print('Error adding crop: $e');
    }
  }
}

// Main Function
void main() {
  runApp(MaterialApp(
    title: 'Crop Management App',
    theme: ThemeData(
      primarySwatch: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: CropListScreen(),
  ));
}
