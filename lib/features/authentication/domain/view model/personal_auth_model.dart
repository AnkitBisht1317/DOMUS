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

  PersonalAuthModel({required UserRepository userRepository}) 
      : _userRepository = userRepository;

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
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    domicileStateController.dispose();
    districtController.dispose();
    super.dispose();
  }
}
