import 'package:flutter/material.dart';

// Define the Profile model
class Profile {
  String name;
  String email;
  String avatarUrl;

  Profile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

// ProfileWidget for displaying profile information
class ProfileWidget extends StatelessWidget {
  final Profile profile;

  ProfileWidget({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profile.avatarUrl),
        ),
        SizedBox(height: 16),
        Text(profile.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(profile.email, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}

// ProfileEditPage for editing profile information
class ProfileEditPage extends StatelessWidget {
  final Profile profile;

  ProfileEditPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: profile.name);
    TextEditingController emailController =
        TextEditingController(text: profile.email);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save profile changes
                profile.name = nameController.text;
                profile.email = emailController.text;
                Navigator.pop(context, profile);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// ProfilePage for displaying and editing profile
class ProfilePage extends StatelessWidget {
  final Profile profile;

  ProfilePage({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileWidget(profile: profile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to edit profile page when button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileEditPage(profile: profile),
            ),
          ).then((updatedProfile) {
            if (updatedProfile != null) {
              // Update profile with changes from edit page
              // Since this is a StatelessWidget, you may need to manage state differently
            }
          });
        },
        child: Icon(Icons.edit),
        tooltip: 'Edit Profile',
      ),
    );
  }
}
