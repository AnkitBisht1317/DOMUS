import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  File? profileImage;
  bool _isLoading = true;
  String? _error;
  bool _hasProfessionalDetails = false;

  bool get isLoading => _isLoading;
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  ProfileViewModel() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user?.phoneNumber == null) {
        _error = "User not authenticated";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch personal details
      final personalSnapshot = await _firestore
          .collection('users')
          .doc(user!.phoneNumber)
          .collection('personalDetails')
          .doc('current')
          .get();

      if (personalSnapshot.exists && personalSnapshot.data() != null) {
        final personalData = personalSnapshot.data()!;
        nameController.text = personalData['fullName'] ?? '';
        mobileController.text = personalData['phoneNumber'] ?? '';
        emailController.text = personalData['email'] ?? '';
        genderController.text = personalData['gender'] ?? '';
        dobController.text = personalData['dob'] ?? '';
        domicileStateController.text = personalData['domicileState'] ?? '';
      }

      // Fetch academic details
      final academicSnapshot = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('academicDetails')
          .doc('current')
          .get();

      if (academicSnapshot.exists && academicSnapshot.data() != null) {
        final academicData = academicSnapshot.data()!;
        yearController.text = academicData['batch'] ?? '';
        ugCollegeController.text = academicData['collegeName'] ?? '';
        ugStateController.text = academicData['collegeState'] ?? '';
      }

      // Fetch professional details
      final professionalSnapshot = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('professional_details')
          .doc('current')
          .get();

      _hasProfessionalDetails = professionalSnapshot.exists && professionalSnapshot.data() != null;
      
      if (_hasProfessionalDetails) {
        final professionalData = professionalSnapshot.data()!;
        designationController.text = professionalData['designation'] ?? '';
        pgCollegeController.text = professionalData['pg_clg_name'] ?? '';
        pgStateController.text = professionalData['pg_state'] ?? '';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = "Failed to load user data: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(String field, String value) async {
    try {
      final user = _auth.currentUser;
      if (user?.phoneNumber == null) return;

      // Determine which collection to update based on the field
      if (['fullName', 'email', 'gender', 'dob', 'domicileState'].contains(field)) {
        // Update personal details
        await _firestore
            .collection('users')
            .doc(user!.phoneNumber)
            .collection('personalDetails')
            .doc('current')
            .update({field: value});
      } else if (['batch', 'collegeName', 'collegeState'].contains(field)) {
        // Map view model field names to database field names
        String dbField = field;
        if (field == 'yearBatch') dbField = 'batch';
        if (field == 'ugCollege') dbField = 'collegeName';
        if (field == 'ugState') dbField = 'collegeState';

        // Update academic details
        await _firestore
            .collection('users')
            .doc(user!.phoneNumber)
            .collection('academicDetails')
            .doc('current')
            .update({dbField: value});
      } else if (['designation', 'pg_clg_name', 'pg_state'].contains(field)) {
        // Update professional details
        await _firestore
            .collection('users')
            .doc(user!.phoneNumber)
            .collection('professional_details')
            .doc('current')
            .update({field: value});
      }
    } catch (e) {
      debugPrint("Error updating user data: $e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
      
      // TODO: Implement profile image upload to Firebase Storage
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user?.phoneNumber == null) return false;

      // Delete all subcollections first
      // Delete personal details
      final personalSnapshot = await _firestore
          .collection('users')
          .doc(user!.phoneNumber)
          .collection('personalDetails')
          .get();
      
      for (var doc in personalSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete academic details
      final academicSnapshot = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('academicDetails')
          .get();
      
      for (var doc in academicSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete professional details
      final professionalSnapshot = await _firestore
          .collection('users')
          .doc(user.phoneNumber)
          .collection('professional_details')
          .get();
      
      for (var doc in professionalSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete main user document
      await _firestore.collection('users').doc(user.phoneNumber).delete();
      
      // Try to delete user authentication, but don't fail if it doesn't work
      try {
        await user.delete();
        debugPrint("User authentication deleted");
      } catch (authError) {
        // Just log the error but continue - we'll sign out instead
        debugPrint("Error deleting authentication: $authError");
        // Sign out the user instead
        await _auth.signOut();
        debugPrint("User signed out instead");
      }
      
      debugPrint("Account data deleted");
      
      // Check if Firestore data still exists
      final docSnapshot = await _firestore
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
