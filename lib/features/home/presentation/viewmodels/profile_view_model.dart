import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  File? profileImage;

  final nameController = TextEditingController(text: "Ankit Bisht");
  final mobileController = TextEditingController(text: "9876543210");
  final emailController = TextEditingController(text: "ankit@example.com");
  final yearController = TextEditingController(text: "2020-2024");
  final ugCollegeController =
      TextEditingController(text: "Govt. Homoeopathic College");
  final pgCollegeController = TextEditingController(text: "Not Applicable");
  final dobController = TextEditingController(text: "01/01/2000");
  final ugStateController = TextEditingController(text: "Uttarakhand");
  final pgStateController = TextEditingController(text: "NA");
  final domicileStateController = TextEditingController(text: "Uttarakhand");
  final genderController = TextEditingController(text: "Male");

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void deleteAccount() {
    // Implement your delete logic
    debugPrint("Account deleted");
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
    super.dispose();
  }
}
