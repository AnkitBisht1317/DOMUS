import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  
  ProfileRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : 
    _firestore = firestore ?? FirebaseFirestore.instance,
    _storage = storage ?? FirebaseStorage.instance;
  
  @override
  Future<String?> uploadProfileImage(File imageFile, String phoneNumber) async {
    try {
      // Sanitize phone number for storage path
      final String sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      if (sanitizedPhone.isEmpty) {
        debugPrint("Error: Invalid phone number for storage path");
        return null;
      }
      
      debugPrint("Starting upload for user: $phoneNumber");
      debugPrint("Image path: ${imageFile.path}");
      
      // Create storage reference
      final storageRef = _storage.ref();
      debugPrint("Storage reference created");
      
      // Create profile image reference
      final profileImageRef = storageRef.child('app_assets/profile_photos_user/$sanitizedPhone.jpg');
      debugPrint("Profile image reference: app_assets/profile_photos_user/$sanitizedPhone.jpg");
      
      // Add metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': sanitizedPhone},
      );
      
      // Upload file with metadata
      debugPrint("Starting file upload...");
      final uploadTask = profileImageRef.putFile(imageFile, metadata);
      
      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      }, onError: (e) {
        debugPrint("Upload task error: $e");
      });
      
      // Wait for upload to complete
      await uploadTask;
      debugPrint("Upload completed");
      
      // Get download URL
      final downloadUrl = await profileImageRef.getDownloadURL();
      debugPrint("Download URL: $downloadUrl");
      
      return downloadUrl;
    } catch (e, stackTrace) {
      debugPrint("Error uploading profile image: $e");
      debugPrint("Stack trace: $stackTrace");
      return null;
    }
  }
  
  @override
  Future<String?> getProfileImageUrl(String phoneNumber) async {
    try {
      // Sanitize phone number
      final String sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Try to get the download URL directly from Storage
      try {
        final profileImageRef = _storage.ref()
            .child('app_assets/profile_photos_user/$sanitizedPhone.jpg');
        return await profileImageRef.getDownloadURL();
      } catch (storageError) {
        debugPrint("Storage error, trying Firestore: $storageError");
        
        // If that fails, try to get it from Firestore
        final docSnapshot = await _firestore
            .collection('users')
            .doc(phoneNumber)
            .collection('personalDetails')
            .doc('current')
            .get();
            
        if (docSnapshot.exists && docSnapshot.data() != null) {
          return docSnapshot.data()!['profilePhotoUrl'];
        }
        return null;
      }
    } catch (e) {
      debugPrint("Error getting profile image URL: $e");
      return null;
    }
  }
  
  @override
  Future<bool> deleteProfileImage(String phoneNumber) async {
    try {
      // Sanitize phone number
      final String sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Delete from Storage
      final profileImageRef = _storage.ref()
          .child('app_assets/profile_photos_user/$sanitizedPhone.jpg');
      await profileImageRef.delete();
      
      // Also remove the URL from Firestore
      await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('personalDetails')
          .doc('current')
          .update({'profilePhotoUrl': FieldValue.delete()});
          
      return true;
    } catch (e) {
      debugPrint("Error deleting profile image: $e");
      return false;
    }
  }
  
  @override
  Future<void> updateProfileData(String phoneNumber, Map<String, dynamic> data) async {
    try {
      // Determine which category to update based on the data keys
      final personalFields = ['fullName', 'email', 'gender', 'dob', 'domicileState', 'profilePhotoUrl'];
      final academicFields = ['batch', 'collegeName', 'collegeState'];
      final professionalFields = ['designation', 'pg_clg_name', 'pg_state', 'ug_state', 'ug_clg_name', 'pg_year'];
      
      // Get current document data
      final docSnapshot = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();
      
      // Initialize maps for each category
      Map<String, dynamic> personalDetails = {};
      Map<String, dynamic> academicDetails = {};
      Map<String, dynamic> professionalDetails = {};
      
      // Get existing data if available
      if (docSnapshot.exists) {
        if (docSnapshot.data()?['personalDetails'] != null) {
          personalDetails = Map<String, dynamic>.from(docSnapshot.data()!['personalDetails']);
        }
        if (docSnapshot.data()?['academicDetails'] != null) {
          academicDetails = Map<String, dynamic>.from(docSnapshot.data()!['academicDetails']);
        }
        if (docSnapshot.data()?['professionalDetails'] != null) {
          professionalDetails = Map<String, dynamic>.from(docSnapshot.data()!['professionalDetails']);
        }
      }
      
      // Sort data into appropriate maps
      data.forEach((key, value) {
        if (personalFields.contains(key)) {
          personalDetails[key] = value;
        } else if (academicFields.contains(key)) {
          academicDetails[key] = value;
        } else if (professionalFields.contains(key)) {
          professionalDetails[key] = value;
        }
      });
      
      // Prepare update data
      Map<String, dynamic> updateData = {};
      
      if (personalDetails.isNotEmpty) {
        updateData['personalDetails'] = personalDetails;
      }
      
      if (academicDetails.isNotEmpty) {
        updateData['academicDetails'] = academicDetails;
      }
      
      if (professionalDetails.isNotEmpty) {
        updateData['professionalDetails'] = professionalDetails;
      }
      
      // Update main document
      if (updateData.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(phoneNumber)
            .set(updateData, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error updating profile data: $e");
      throw Exception('Failed to update profile data: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>?> loadProfileData(String phoneNumber) async {
    try {
      final result = <String, dynamic>{};
      
      // Fetch main document data
      final docSnapshot = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();
  
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Extract personal details
        if (docSnapshot.data()!.containsKey('personalDetails')) {
          final personalDetails = docSnapshot.data()!['personalDetails'] as Map<String, dynamic>;
          result.addAll(personalDetails);
        }
        
        // Extract academic details
        if (docSnapshot.data()!.containsKey('academicDetails')) {
          final academicDetails = docSnapshot.data()!['academicDetails'] as Map<String, dynamic>;
          result.addAll(academicDetails);
        }
        
        // Extract professional details
        if (docSnapshot.data()!.containsKey('professionalDetails')) {
          final professionalDetails = docSnapshot.data()!['professionalDetails'] as Map<String, dynamic>;
          result.addAll(professionalDetails);
        }
      }
      
      return result.isNotEmpty ? result : null;
    } catch (e) {
      debugPrint("Error loading profile data: $e");
      return null;
    }
  }
}