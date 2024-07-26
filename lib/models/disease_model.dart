import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Disease Model
class Disease {
  final String id;
  final String name;
  final String symptoms;
  final String treatment;
  final String prevention;

  Disease({
    required this.id,
    required this.name,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      name: json['name'],
      symptoms: json['symptoms'],
      treatment: json['treatment'],
      prevention: json['prevention'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symptoms': symptoms,
      'treatment': treatment,
      'prevention': prevention,
    };
  }

  @override
  String toString() {
    return 'Disease(id: $id, name: $name, symptoms: $symptoms, treatment: $treatment, prevention: $prevention)';
  }
}

// Disease Service
class DiseaseService {
  final String _baseUrl = 'https://api.example.com/diseases'; // Replace with your API endpoint

  Future<List<Disease>> fetchDiseases() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Disease.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load diseases');
      }
    } catch (e) {
      throw Exception('Error fetching diseases: $e');
    }
  }

  Future<Disease> fetchDiseaseById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode == 200) {
        return Disease.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load disease');
      }
    } catch (e) {
      throw Exception('Error fetching disease: $e');
    }
  }

  Future<void> updateDisease(Disease disease) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${disease.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(disease.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update disease');
      }
    } catch (e) {
      throw Exception('Error updating disease: $e');
    }
  }
}

// Disease Controller
class DiseaseController {
  final DiseaseService _diseaseService;

  DiseaseController(this._diseaseService);

  Future<List<Disease>> getDiseases() async {
    try {
      return await _diseaseService.fetchDiseases();
    } catch (e) {
      print('Error fetching diseases: $e');
      rethrow;
    }
  }

  Future<Disease> getDiseaseById(String id) async {
    try {
      return await _diseaseService.fetchDiseaseById(id);
    } catch (e) {
      print('Error fetching disease by ID: $e');
      rethrow;
    }
  }

  Future<void> updateDisease(Disease disease) async {
    try {
      await _diseaseService.updateDisease(disease);
    } catch (e) {
      print('Error updating disease: $e');
      rethrow;
    }
  }
}

// Disease Widget
class DiseaseWidget extends StatelessWidget {
  final Disease disease;
  final VoidCallback onEdit;

  const DiseaseWidget({
    Key? key,
    required this.disease,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${disease.name}', style: Theme.of(context).textTheme.headline6),
          Text('Symptoms: ${disease.symptoms}', style: Theme.of(context).textTheme.bodyText1),
          Text('Treatment: ${disease.treatment}', style: Theme.of(context).textTheme.bodyText1),
          Text('Prevention: ${disease.prevention}', style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onEdit,
            child: Text('Edit Disease'),
          ),
        ],
      ),
    );
  }
}

// Disease Edit Form
class DiseaseEditForm extends StatefulWidget {
  final Disease disease;
  final DiseaseController diseaseController;

  const DiseaseEditForm({
    Key? key,
    required this.disease,
    required this.diseaseController,
  }) : super(key: key);

  @override
  _DiseaseEditFormState createState() => _DiseaseEditFormState();
}

class _DiseaseEditFormState extends State<DiseaseEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _symptomsController;
  late TextEditingController _treatmentController;
  late TextEditingController _preventionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.disease.name);
    _symptomsController = TextEditingController(text: widget.disease.symptoms);
    _treatmentController = TextEditingController(text: widget.disease.treatment);
    _preventionController = TextEditingController(text: widget.disease.prevention);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _symptomsController,
            decoration: InputDecoration(labelText: 'Symptoms'),
          ),
          TextFormField(
            controller: _treatmentController,
            decoration: InputDecoration(labelText: 'Treatment'),
          ),
          TextFormField(
            controller: _preventionController,
            decoration: InputDecoration(labelText: 'Prevention'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveDisease,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _saveDisease() async {
    final disease = Disease(
      id: widget.disease.id,
      name: _nameController.text,
      symptoms: _symptomsController.text,
      treatment: _treatmentController.text,
      prevention: _preventionController.text,
    );

    try {
      await widget.diseaseController.updateDisease(disease);
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to update disease');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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

// Disease List Screen
class DiseaseListScreen extends StatefulWidget {
  @override
  _DiseaseListScreenState createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  final DiseaseController _diseaseController = DiseaseController(DiseaseService());
  late Future<List<Disease>> _diseasesFuture;

  @override
  void initState() {
    super.initState();
    _diseasesFuture = _diseaseController.getDiseases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diseases'),
      ),
      body: FutureBuilder<List<Disease>>(
        future: _diseasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No diseases found'));
          } else {
            final diseases = snapshot.data!;
            return ListView.builder(
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                return ListTile(
                  title: Text(disease.name),
                  subtitle: Text(disease.symptoms),
                  onTap: () => _viewDisease(disease),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _viewDisease(Disease disease) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiseaseEditForm(
          disease: disease,
          diseaseController: _diseaseController,
        ),
      ),
    );
  }
}