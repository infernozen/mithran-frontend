import '../models/profile_model.dart';

// Custom exception for the repository
class ProfileRepositoryException implements Exception {
  final String message;
  ProfileRepositoryException(this.message);

  @override
  String toString() => 'ProfileRepositoryException: $message';
}

// ProfileRepository class definition
class ProfileRepository {
  // Simulated in-memory storage for profiles
  final Map<String, Profile> _profileStorage = {};

  // Lock for thread-safe operations
  final _lock = Object();

  // Fetch a profile by ID
  Future<Profile> getProfile(String id) async {
    try {
      _lock;
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }
      final profile = _profileStorage[id];
      if (profile == null) {
        throw ProfileRepositoryException('Profile with ID $id not found');
      }
      return profile;
    } catch (e) {
      throw ProfileRepositoryException('Error fetching profile by ID: $e');
    }
  }

  // Save a profile to the repository
  Future<void> saveProfile(Profile profile) async {
    try {
      _lock;
      if (profile == null || profile.id == null || profile.id.isEmpty) {
        throw ArgumentError('Profile and its ID cannot be null or empty');
      }
      _profileStorage[profile.id!] = profile;
      // Simulate a delay to mimic a real database operation
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw ProfileRepositoryException('Error saving profile: $e');
    }
  }

  // Update an existing profile
  Future<void> updateProfile(Profile updatedProfile) async {
    try {
      _lock;
      if (updatedProfile == null || updatedProfile.id == null || updatedProfile.id.isEmpty) {
        throw ArgumentError('Updated profile and its ID cannot be null or empty');
      }
      final id = updatedProfile.id!;
      if (!_profileStorage.containsKey(id)) {
        throw ProfileRepositoryException('Profile with ID $id not found');
      }
      _profileStorage[id] = updatedProfile;
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw ProfileRepositoryException('Error updating profile: $e');
    }
  }

  // Delete a profile by ID
  Future<void> deleteProfile(String id) async {
    try {
      _lock;
      if (id == null || id.isEmpty) {
        throw ArgumentError('ID cannot be null or empty');
      }
      final removed = _profileStorage.remove(id);
      if (removed == null) {
        throw ProfileRepositoryException('Profile with ID $id not found');
      }
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      throw ProfileRepositoryException('Error deleting profile: $e');
    }
  }

  // Fetch profiles by a specific attribute (e.g., email contains keyword)
  Future<List<Profile>> fetchProfilesByAttribute(String attribute, String value) async {
    try {
      _lock;
      if (attribute == null || value == null) {
        throw ArgumentError('Attribute and value cannot be null');
      }

      return List.unmodifiable(_profileStorage.values.where((profile) {
        if (attribute == 'email') {
          return profile.email.contains(value);
        } else {
          throw ArgumentError('Unsupported attribute');
        }
      }).toList());
    } catch (e) {
      throw ProfileRepositoryException('Error fetching profiles by attribute: $e');
    }
  }

  // Fetch profiles by multiple attributes
  Future<List<Profile>> fetchProfilesByAttributes(Map<String, String> attributes) async {
    try {
      _lock;
      if (attributes == null || attributes.isEmpty) {
        throw ArgumentError('Attributes cannot be null or empty');
      }

      return List.unmodifiable(_profileStorage.values.where((profile) {
        bool matches = true;
        attributes.forEach((key, value) {
          if (key == 'email') {
            if (!profile.email.contains(value)) {
              matches = false;
            }
          } else {
            throw ArgumentError('Unsupported attribute');
          }
        });
        return matches;
      }).toList());
    } catch (e) {
      throw ProfileRepositoryException('Error fetching profiles by multiple attributes: $e');
    }
  }

  // Fetch profiles within a specific range (e.g., age range)
  Future<List<Profile>> fetchProfilesInRange(int minAge, int maxAge) async {
    try {
      _lock;
      if (minAge < 0 || maxAge < 0 || minAge > maxAge) {
        throw ArgumentError('Invalid age range');
      }

      return List.unmodifiable(_profileStorage.values.where((profile) {
        // Assuming the Profile model has an 'age' attribute
        return profile.age != null && profile.age! >= minAge && profile.age! <= maxAge;
      }).toList());
    } catch (e) {
      throw ProfileRepositoryException('Error fetching profiles in age range: $e');
    }
  }

  // Fetch profiles by a keyword in any attribute (e.g., name or email)
  Future<List<Profile>> searchProfiles(String keyword) async {
    try {
      _lock;
      if (keyword == null || keyword.isEmpty) {
        throw ArgumentError('Keyword cannot be null or empty');
      }

      return List.unmodifiable(_profileStorage.values.where((profile) {
        return profile.name.contains(keyword) || profile.email.contains(keyword);
      }).toList());
    } catch (e) {
      throw ProfileRepositoryException('Error searching profiles: $e');
    }
  }
}
