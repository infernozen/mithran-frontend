import 'package:flutter/material.dart';
import '../models/profile_model.dart';

class ProfileEditPage extends StatelessWidget {
  final Profile profile;

  ProfileEditPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    // Controllers to manage text field inputs
    final TextEditingController nameController = TextEditingController(text: profile.name);
    final TextEditingController emailController = TextEditingController(text: profile.email);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text field for editing name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16.0), // Spacing between fields

            // Text field for editing email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0), // Spacing before button

            // Save button to update profile
            ElevatedButton(
              onPressed: () {
                // Validate inputs
                if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  // Update profile with new values
                  profile.name = nameController.text;
                  profile.email = emailController.text;

                  // Use Navigator.pop to return to the previous screen
                  Navigator.pop(context, profile);
                } else {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
