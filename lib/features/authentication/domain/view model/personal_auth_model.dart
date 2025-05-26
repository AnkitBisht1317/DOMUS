import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/personal_user_model.dart';
import '../repositories/user_repository.dart';

class PersonalAuthModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final UserRepository _userRepository;
  final FirebaseAuth _auth;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final domicileStateController = TextEditingController();
  final districtController = TextEditingController();

  String selectedGender = 'Other';
  String selectedCountry = 'India';
  bool isPhoneEditable = false;
  bool isSaving = false;
  String? error;
  bool isLoading = false;

  PersonalAuthModel({
    required UserRepository userRepository,
    FirebaseAuth? auth,
  }) : _userRepository = userRepository,
       _auth = auth ?? FirebaseAuth.instance {
    // Initialize phone number from Firebase Auth
    final user = _auth.currentUser;
    if (user?.phoneNumber != null) {
      phoneController.text = user!.phoneNumber!;
      // Fetch user details if phone number exists
      fetchUserDetails();
    }
  }

  Future<void> fetchUserDetails() async {
    if (_auth.currentUser == null) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final userDetails = await _userRepository.getUserDetails(phoneController.text);
      if (userDetails != null) {
        // Fill all the fields with user data
        fullNameController.text = userDetails.fullName;
        emailController.text = userDetails.email;
        selectedGender = userDetails.gender;
        dobController.text = userDetails.dob;
        selectedCountry = userDetails.country;
        domicileStateController.text = userDetails.domicileState;
        districtController.text = userDetails.district;
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void setCountry(String value) {
    selectedCountry = value;
    notifyListeners();
  }

  void togglePhoneEditable() {
    // Phone number should not be editable as it comes from Firebase Auth
    ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Phone number cannot be changed here. Please sign out and sign in with a different number.'),
      ),
    );
  }

  void setDOB(String dob) {
    dobController.text = dob;
    notifyListeners();
  }

  bool validateAndSave() {
    if (_auth.currentUser == null) {
      error = 'No authenticated user found';
      notifyListeners();
      return false;
    }
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> saveUserDetails() async {
    if (!validateAndSave()) return false;
    
    try {
      isSaving = true;
      error = null;
      notifyListeners();

      final userDetails = collectUserDetails();
      await _userRepository.saveUserDetails(userDetails);
      
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  UserDetails collectUserDetails() {
    return UserDetails(
      fullName: fullNameController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      gender: selectedGender,
      dob: dobController.text,
      country: selectedCountry,
      domicileState: domicileStateController.text,
      district: districtController.text,
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    domicileStateController.dispose();
    districtController.dispose();
    super.dispose();
  }
}
