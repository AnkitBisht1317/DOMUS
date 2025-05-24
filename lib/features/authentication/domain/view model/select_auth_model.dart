import 'package:flutter/material.dart';

class SelectAuthModel with ChangeNotifier {
  String? _userType;
  String? _gender;

  String? get userType => _userType;
  String? get gender => _gender;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }
}
