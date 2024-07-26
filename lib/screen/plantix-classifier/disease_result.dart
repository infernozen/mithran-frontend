import 'package:flutter/material.dart';
import '../models/disease_model.dart';

// A widget to display the result of a disease analysis
class DiseaseResultPage extends StatelessWidget {
  final Disease disease;

  DiseaseResultPage({Key? key, required this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Result'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality here
              // For example, using the share_plus package
              // Share.share('Check out this disease: ${disease.name} - ${disease.description}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disease: ${disease.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              disease.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Additional Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display additional information if available
            if (disease.symptoms.isNotEmpty) ...[
              Text(
                'Symptoms:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                disease.symptoms.join(', '),
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (disease.treatment.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Treatment:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                disease.treatment,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
