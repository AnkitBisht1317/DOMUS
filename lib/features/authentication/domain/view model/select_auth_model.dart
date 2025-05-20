import 'package:flutter/material.dart';

class SelectAuthModel with ChangeNotifier {
  String? _userType;

  String? get userType => _userType;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }
}
