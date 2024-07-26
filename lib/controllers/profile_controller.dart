import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Profile Model
class Profile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, address: $address)';
  }
}

// Profile Service
class ProfileService {
  final String _baseUrl =
      'https://api.example.com/profile'; // Replace with your API endpoint

  Future<Profile> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return Profile.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(profile.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}

// Profile Controller
class ProfileController {
  final ProfileService _profileService;

  ProfileController(this._profileService);

  Future<Profile> getProfile() async {
    try {
      return await _profileService.fetchProfile();
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(Profile profile) async {
    try {
      await _profileService.updateProfile(profile);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}

// Profile Helper Functions
Profile createProfile(
    String id, String name, String email, String phoneNumber, String address) {
  return Profile(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    address: address,
  );
}

bool validateEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}

bool validatePhoneNumber(String phoneNumber) {
  final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
  return phoneRegex.hasMatch(phoneNumber);
}

// Profile Widget
class ProfileWidget extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEdit;

  const ProfileWidget({
    Key? key,
    required this.profile,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${profile.name}',
              style: Theme.of(context).textTheme.headline6),
          Text('Email: ${profile.email}',
              style: Theme.of(context).textTheme.bodyText1),
          Text('Phone: ${profile.phoneNumber}',
              style: Theme.of(context).textTheme.bodyText1),
          Text('Address: ${profile.address}',
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onEdit,
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

// Profile Edit Form
class ProfileEditForm extends StatefulWidget {
  final Profile profile;
  final ProfileController profileController;

  const ProfileEditForm({
    Key? key,
    required this.profile,
    required this.profileController,
  }) : super(key: key);

  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _addressController = TextEditingController(text: widget.profile.address);
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
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    final profile = Profile(
      id: widget.profile.id,
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
    );

    if (!validateEmail(profile.email)) {
      _showError('Invalid email address');
      return;
    }

    if (!validatePhoneNumber(profile.phoneNumber)) {
      _showError('Invalid phone number');
      return;
    }

    try {
      await widget.profileController.updateProfile(profile);
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to update profile');
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

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController =
      ProfileController(ProfileService());
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No profile found'));
          } else {
            return ProfileWidget(
              profile: snapshot.data!,
              onEdit: _editProfile,
            );
          }
        },
      ),
    );
  }

  void _editProfile() async {
    final profile = await _profileController.getProfile();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileEditForm(
          profile: profile,
          profileController: _profileController,
        ),
      ),
    );
  }
}
