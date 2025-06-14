import 'package:flutter/material.dart';

import '../models/student_academic_details.dart';
import '../repositories/user_repository.dart';

class StudentAuthModel with ChangeNotifier {
  final UserRepository _userRepository;
  String? _selectedBatch;
  String? _selectedState;
  String? _selectedCollege;
  bool _isSaving = false;
  String? _error;

  StudentAuthModel({required UserRepository userRepository})
      : _userRepository = userRepository;

  String? get selectedBatch => _selectedBatch;
  String? get selectedState => _selectedState;
  String? get selectedCollege => _selectedCollege;
  bool get isSaving => _isSaving;
  String? get error => _error;

  void setBatch(String? batch) {
    _selectedBatch = batch;
    notifyListeners();
  }

  void setState(String? state) {
    _selectedState = state;
    _selectedCollege = null; // Reset college when state changes
    notifyListeners();
  }

  void setCollege(String? college) {
    _selectedCollege = college;
    notifyListeners();
  }

  bool isFormValid() {
    return _selectedBatch != null &&
        _selectedState != null &&
        _selectedCollege != null;
  }

  Future<bool> saveAcademicDetails(String phoneNumber) async {
    if (!isFormValid()) return false;

    try {
      _isSaving = true;
      _error = null;
      notifyListeners();

      final academicDetails = StudentAcademicDetails(
        batch: _selectedBatch!,
        collegeState: _selectedState!,
        collegeName: _selectedCollege!,
      );

      await _userRepository.saveAcademicDetails(phoneNumber, academicDetails);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
