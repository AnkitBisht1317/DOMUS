import 'dart:io';

abstract class ProfileRepository {
  /// Upload a profile image to Firebase Storage
  /// Returns the download URL if successful
  Future<String?> uploadProfileImage(File imageFile, String phoneNumber);
  
  /// Get the profile image URL for a user
  Future<String?> getProfileImageUrl(String phoneNumber);
  
  /// Delete the profile image for a user
  Future<bool> deleteProfileImage(String phoneNumber);
  
  /// Update user's profile data in Firestore
  Future<void> updateProfileData(String phoneNumber, Map<String, dynamic> data);
  
  /// Load user's profile data from Firestore
  Future<Map<String, dynamic>?> loadProfileData(String phoneNumber);
}