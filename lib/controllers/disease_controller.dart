import 'dart:convert';
import 'package:http/http.dart' as http;

// Disease Model
class Disease {
  final int id;
  final String name;
  final String description;
  final String severity;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'severity': severity,
    };
  }

  @override
  String toString() {
    return 'Disease(id: $id, name: $name, description: $description, severity: $severity)';
  }
}

// Disease Service
class DiseaseService {
  final String _apiUrl = 'https://api.example.com/disease-analysis'; // Replace with your API endpoint

  Future<Disease> analyzeImage(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'image_url': imageUrl}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Disease.fromJson(data);
      } else {
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }
}

// Disease Controller
class DiseaseController {
  final DiseaseService _diseaseService;

  DiseaseController(this._diseaseService);

  Future<Disease> analyzeImage(String imageUrl) async {
    try {
      final disease = await _diseaseService.analyzeImage(imageUrl);
      return disease;
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }
}

// Disease Analysis Screen
import 'package:flutter/material.dart';

class DiseaseAnalysisScreen extends StatefulWidget {
  @override
  _DiseaseAnalysisScreenState createState() => _DiseaseAnalysisScreenState();
}

class _DiseaseAnalysisScreenState extends State<DiseaseAnalysisScreen> {
  final _imageUrlController = TextEditingController();
  final DiseaseController _diseaseController = DiseaseController(DiseaseService());
  Disease? _disease;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: Text('Analyze Image'),
            ),
            SizedBox(height: 20),
            if (_disease != null) ...[
              Text('Disease Name: ${_disease!.name}'),
              Text('Description: ${_disease!.description}'),
              Text('Severity: ${_disease!.severity}'),
            ],
            if (_errorMessage.isNotEmpty) ...[
              Text(
                'Error: $_errorMessage',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _analyzeImage() async {
    final imageUrl = _imageUrlController.text;
    try {
      final disease = await _diseaseController.analyzeImage(imageUrl);
      setState(() {
        _disease = disease;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _disease = null;
        _errorMessage = e.toString();
      });
    }
  }
}

// Main Function
void main() {
  runApp(MaterialApp(
    title: 'Disease Analysis App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: DiseaseAnalysisScreen(),
  ));
}
