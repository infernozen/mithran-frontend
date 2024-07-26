import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

// Image Model
class UploadedImage {
  final String imageUrl;
  final String imageId;
  final DateTime uploadTime;

  UploadedImage({
    required this.imageUrl,
    required this.imageId,
    required this.uploadTime,
  });

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      imageUrl: json['image_url'],
      imageId: json['image_id'],
      uploadTime: DateTime.parse(json['upload_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'image_id': imageId,
      'upload_time': uploadTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UploadedImage(imageUrl: $imageUrl, imageId: $imageId, uploadTime: $uploadTime)';
  }
}

// Image Service
class ImageService {
  final String _uploadUrl = 'https://api.example.com/upload'; // Replace with your API endpoint

  Future<UploadedImage> uploadImage(String filePath) async {
    try {
      final uri = Uri.parse(_uploadUrl);
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType('image', 'jpeg'), // Adjust content type based on image format
        ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        return UploadedImage.fromJson(data);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}

// Image Controller
class ImageController {
  final ImageService _imageService;

  ImageController(this._imageService);

  Future<UploadedImage> uploadImage(String filePath) async {
    try {
      final uploadedImage = await _imageService.uploadImage(filePath);
      return uploadedImage;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> handleImageUpload(String filePath) async {
    try {
      final uploadedImage = await uploadImage(filePath);
      // Additional logic such as updating UI or storing image details
      print('Image uploaded successfully: $uploadedImage');
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }
}

// Image Upload Screen
import 'package:flutter/material.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final _filePathController = TextEditingController();
  final ImageController _imageController = ImageController(ImageService());
  String _imageUrl = '';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _filePathController,
              decoration: InputDecoration(labelText: 'Image File Path'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            if (_imageUrl.isNotEmpty) ...[
              Text('Image URL: $_imageUrl'),
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

  void _uploadImage() async {
    final filePath = _filePathController.text;
    try {
      final uploadedImage = await _imageController.uploadImage(filePath);
      setState(() {
        _imageUrl = uploadedImage.imageUrl;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _imageUrl = '';
        _errorMessage = e.toString();
      });
    }
  }
}

// Main Function
void main() {
  runApp(MaterialApp(
    title: 'Image Upload App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ImageUploadScreen(),
  ));
}
