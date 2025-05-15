import 'package:flutter/material.dart';

import 'user_model.dart';

class AuthViewModel extends ChangeNotifier {
  // The data that holds the data
  UserModel _user = UserModel(phoneNumber: '', otp: '', isChecked: false);

  // Getters
  String get phoneNumber => _user.phoneNumber;
  String get otp => _user.otp;
  bool get isChecked => _user.isChecked;

  // Setters
  void setPhoneNumber(String phone) {
    _user.phoneNumber = phone;
    notifyListeners(); // Notify listeners when the value changes
  }

  void setOtp(String otp) {
    _user.otp = otp;
    notifyListeners();
  }

  void toggleCheckbox(bool value) {
    _user.isChecked = value;
    notifyListeners();
  }

  // Validate OTP and checkbox
  bool validateForm() {
    return _user.isChecked && _user.otp.length == 6;
  }
}
