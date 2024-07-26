import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _profileRepository;

  // Constructor to inject the repository dependency
  ProfileService(this._profileRepository);

  // Cache for storing the fetched profile
  Profile? _cachedProfile;

  // Fetch the profile with optional caching
  Future<Profile> fetchProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProfile != null) {
      return _cachedProfile!;
    }

    try {
      final profile = await _profileRepository.getProfile();
      _cachedProfile = profile;
      return profile;
    } catch (e) {
      // Handle errors appropriately
      throw Exception('Error fetching profile: $e');
    }
  }

  // Update the profile and clear the cache
  Future<void> updateProfile(Profile profile) async {
    try {
      await _profileRepository.saveProfile(profile);
      // Update the cache with the new profile
      _cachedProfile = profile;
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Utility method to handle HTTP errors
  void handleHttpError(Exception e) {
    // Implement error handling, e.g., logging or user notifications
    print('HTTP Error: $e');
  }

  // Logging for requests and responses
  void logRequest(String method, String endpoint, {Map<String, dynamic>? data}) {
    print('Request Method: $method');
    print('Request Endpoint: $endpoint');
    if (data != null) {
      print('Request Data: ${data}');
    }
  }

  void logResponse(int statusCode, String responseBody) {
    print('Response Status Code: $statusCode');
    print('Response Body: $responseBody');
  }
}

// Example ProfileRepository class
class ProfileRepository {
  final String baseUrl = 'https://api.example.com/profile';

  // Fetch the profile
  Future<Profile> getProfile() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final profileData = jsonDecode(response.body);
      return Profile.fromJson(profileData);
    } else {
      throw HttpException('Failed to fetch profile: ${response.statusCode}');
    }
  }

  // Save the profile
  Future<void> saveProfile(Profile profile) async {
    final url = Uri.parse(baseUrl);
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw HttpException('Failed to update profile: ${response.statusCode}');
    }
  }
}

// Example Profile model
class Profile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
