import 'package:flutter/material.dart';
import '../models/disease_model.dart';

class DiseaseResultWidget extends StatelessWidget {
  final Disease disease;

  DiseaseResultWidget({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
              final RenderBox box = context.findRenderObject() as RenderBox;
              Share.share(
                'Check out this disease information:\n\n'
                'Disease: ${disease.name}\n'
                'Description: ${disease.description}',
                subject: 'Disease Information',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiseaseHeader(),
            SizedBox(height: 20),
            _buildDiseaseDescription(),
            SizedBox(height: 20),
            _buildAdditionalInformation(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseHeader() {
    return Row(
      children: [
        Icon(
          Icons.warning,
          color: Colors.red,
          size: 40,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            disease.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiseaseDescription() {
    return Text(
      'Description: ${disease.description}',
      style: TextStyle(fontSize: 18, color: Colors.black87),
    );
  }

  Widget _buildAdditionalInformation() {
    // Example of additional information you might want to add
    // You can adjust or expand this based on the actual data available in the Disease model
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        // Example fields, adjust based on actual Disease model properties
        _buildInfoRow('Symptoms', disease.symptoms ?? 'Not available'),
        _buildInfoRow('Prevention', disease.prevention ?? 'Not available'),
        _buildInfoRow('Treatment', disease.treatment ?? 'Not available'),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
