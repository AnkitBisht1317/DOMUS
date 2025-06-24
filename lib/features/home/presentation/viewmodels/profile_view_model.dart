import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  File? profileImage;
  String? profileImageUrl;
  bool _isLoading = true;
  bool _isImageLoading = false; // Add this flag
  String? _error;
  bool _hasProfessionalDetails = false;

  bool get isLoading => _isLoading;
  bool get isImageLoading => _isImageLoading; // Add this getter
  String? get error => _error;
  bool get hasProfessionalDetails => _hasProfessionalDetails;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final yearController = TextEditingController();
  final ugCollegeController = TextEditingController();
  final pgCollegeController = TextEditingController();
  final dobController = TextEditingController();
  final ugStateController = TextEditingController();
  final pgStateController = TextEditingController();
  final domicileStateController = TextEditingController();
  final genderController = TextEditingController();
  final designationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final ProfileRepository _profileRepository;

  ProfileViewModel({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepositoryImpl() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      _isImageLoading = true; // Set to true when starting to load
      notifyListeners();

      final user = _auth.currentUser;
      if (user?.phoneNumber == null) {
        _error = "User not authenticated";
        _isLoading = false;
        _isImageLoading = false; // Make sure to set to false
        notifyListeners();
        return;
      }

      // Load all profile data using the repository
      final profileData =
          await _profileRepository.loadProfileData(user!.phoneNumber!);

      if (profileData != null) {
        // Set personal details
        nameController.text = profileData['fullName'] ?? '';
        mobileController.text = profileData['phoneNumber'] ?? '';
        emailController.text = profileData['email'] ?? '';
        genderController.text = profileData['gender'] ?? '';
        dobController.text = profileData['dob'] ?? '';
        domicileStateController.text = profileData['domicileState'] ?? '';

        // Get profile image URL
        profileImageUrl = profileData['profilePhotoUrl'];

        // Set academic details
        yearController.text = profileData['batch'] ?? '';
        ugCollegeController.text = profileData['collegeName'] ?? '';
        ugStateController.text = profileData['collegeState'] ?? '';

        // Set professional details if they exist
        _hasProfessionalDetails = profileData.containsKey('designation');
        if (_hasProfessionalDetails) {
          designationController.text = profileData['designation'] ?? '';
          pgCollegeController.text = profileData['pg_clg_name'] ?? '';
          pgStateController.text = profileData['pg_state'] ?? '';
        }
      }

      // Keep isImageLoading true until we explicitly verify the image is loaded
      if (profileImageUrl != null) {
        // Create a network image and add a listener to know when it's loaded
        final networkImage = NetworkImage(profileImageUrl!);
        final imageStream = networkImage.resolve(ImageConfiguration());
        final completer = Completer<void>();

        final listener = ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onError: (exception, stackTrace) {
            if (!completer.isCompleted) {
              completer.completeError(exception);
            }
          },
        );

        imageStream.addListener(listener);

        // Wait for image to load or timeout after 5 seconds
        try {
          await completer.future.timeout(Duration(seconds: 5));
        } catch (e) {
          debugPrint("Error loading profile image: $e");
        } finally {
          imageStream.removeListener(listener);
          _isImageLoading = false;
        }
      } else {
        _isImageLoading = false;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = "Failed to load user data: $e";
      _isLoading = false;
      _isImageLoading = false; // Always set to false on error
      notifyListeners();
    }
  }

  Future<void> updateUserData(String field, String value) async {
    try {
      final user = _auth.currentUser;
      if (user?.phoneNumber == null) return;

      // Use the repository to update the data
      await _profileRepository
          .updateProfileData(user!.phoneNumber!, {field: value});
    } catch (e) {
      debugPrint("Error updating user data: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        _isImageLoading = true; // Set to true when starting to upload
        notifyListeners();

        // Get current user
        final user = _auth.currentUser;
        if (user?.phoneNumber == null) {
          debugPrint("Error: User phone number is null");
          _isImageLoading = false; // Make sure to set to false on error
          notifyListeners();
          return;
        }

        // Use the repository to upload the image
        final downloadUrl = await _profileRepository.uploadProfileImage(
            profileImage!, user!.phoneNumber!);

        if (downloadUrl != null) {
          profileImageUrl = downloadUrl;

          // Update the profile photo URL in Firestore
          await _profileRepository.updateProfileData(
              user.phoneNumber!, {'profilePhotoUrl': downloadUrl});
        }

        // Always set to false when done, regardless of success or failure
        _isImageLoading = false;
        notifyListeners();
        debugPrint("Profile image updated successfully");
      }
    } catch (e, stackTrace) {
      debugPrint("Error uploading profile image: $e");
      debugPrint("Stack trace: $stackTrace");
      _isImageLoading = false; // Set to false on error
      notifyListeners();
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user?.phoneNumber == null) return false;

      // Delete profile image using the repository
      await _profileRepository.deleteProfileImage(user!.phoneNumber!);

      // Delete all subcollections first
      // Delete personal details
      final personalSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.phoneNumber)
          .collection('personalDetails')
          .get();

      for (var doc in personalSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete academic details
      final academicSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.phoneNumber)
          .collection('academicDetails')
          .get();

      for (var doc in academicSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete professional details
      final professionalSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.phoneNumber)
          .collection('professional_details')
          .get();

      for (var doc in professionalSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete main user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.phoneNumber)
          .delete();

      // Try to delete user authentication, but don't fail if it doesn't work
      try {
        await user.delete();
        debugPrint("User authentication deleted");
      } catch (authError) {
        debugPrint("Error deleting authentication: $authError");
        await _auth.signOut();
        debugPrint("User signed out instead");
      }

      debugPrint("Account data deleted");

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.phoneNumber)
          .get();

      // Return true even if only the Firestore data was deleted
      return !docSnapshot.exists;
    } catch (e) {
      debugPrint("Error deleting account: $e");
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    yearController.dispose();
    ugCollegeController.dispose();
    pgCollegeController.dispose();
    dobController.dispose();
    ugStateController.dispose();
    pgStateController.dispose();
    domicileStateController.dispose();
    genderController.dispose();
    designationController.dispose();
    super.dispose();
  }
}
