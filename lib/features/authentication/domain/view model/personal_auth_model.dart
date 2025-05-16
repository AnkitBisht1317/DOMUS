import 'package:flutter/material.dart';

import '../models/personal_user_model.dart';

class PersonalAuthModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final domicileStateController = TextEditingController();
  final districtController = TextEditingController();

  String selectedGender = 'Other';
  String selectedCountry = 'India';

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void setCountry(String value) {
    selectedCountry = value;
    notifyListeners();
  }

  void setDOB(String dob) {
    dobController.text = dob;
    notifyListeners();
  }

  bool validateAndSave() {
    return formKey.currentState?.validate() ?? false;
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
