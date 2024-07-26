import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: ImageUploadWidget(),
    );
  }
}

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  XFile? _imageFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  // Function to capture an image from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  // Function to upload the selected image
  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      setState(() {
        _isUploading = true;
      });

      // Replace with your actual image upload logic
      await Future.delayed(Duration(seconds: 2)); // Simulate upload delay

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_imageFile != null)
            Image.file(
              File(_imageFile!.path),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            )
          else
            Text('No image selected'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Pick Image from Gallery'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                child: Text('Capture Image from Camera'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isUploading ? null : _uploadImage,
            child: _isUploading
                ? CircularProgressIndicator()
                : Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
