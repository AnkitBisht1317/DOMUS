import 'package:flutter/material.dart';
import '../models/personal_user_model.dart';
import '../repositories/user_repository.dart';

class PersonalAuthModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final UserRepository _userRepository;

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

  PersonalAuthModel({required UserRepository userRepository}) 
      : _userRepository = userRepository {
    // Listen to phone number changes
    phoneController.addListener(_onPhoneNumberChanged);
  }

  void _onPhoneNumberChanged() {
    if (phoneController.text.length >= 10) {
      fetchUserDetails();
    }
  }

  Future<void> fetchUserDetails() async {
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
    isPhoneEditable = !isPhoneEditable;
    if (isPhoneEditable) {
      // Clear all fields when phone becomes editable
      fullNameController.clear();
      emailController.clear();
      dobController.clear();
      domicileStateController.clear();
      districtController.clear();
      selectedGender = 'Other';
      selectedCountry = 'India';
    }
    notifyListeners();
  }

  void setDOB(String dob) {
    dobController.text = dob;
    notifyListeners();
  }

  bool validateAndSave() {
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
    phoneController.removeListener(_onPhoneNumberChanged);
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    domicileStateController.dispose();
    districtController.dispose();
    super.dispose();
  }
}
