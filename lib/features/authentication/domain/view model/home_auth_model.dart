import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_user_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserModel _user = UserModel(phoneNumber: '', otp: '', isChecked: false);
  String? _verificationId;
  bool _otpSent = false;

  // Getters
  String get phoneNumber => _user.phoneNumber;
  String get otp => _user.otp;
  bool get isChecked => _user.isChecked;
  bool get otpSent => _otpSent;

  // Setters
  void setPhoneNumber(String phone) {
    _user.phoneNumber = phone;
    notifyListeners();
  }

  void setOtp(String otp) {
    _user.otp = otp;
    notifyListeners();
  }

  void toggleCheckbox(bool value) {
    _user.isChecked = value;
    notifyListeners();
  }

  // Validate full form before submitting
  bool validateForm() {
    return _user.isChecked && _user.otp.length == 6;
  }

  // Send OTP using Firebase
  Future<void> sendOtp(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _otpSent = false;

    await auth.verifyPhoneNumber(
      phoneNumber: _user.phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Optional: You can auto-login if OTP auto-retrieved
      },
      verificationFailed: (FirebaseAuthException e) {
       
        print("FirebaseAuthException: ${e.code} => ${e.message}");
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _otpSent = true;
        notifyListeners();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP sent successfully")));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Verify OTP
  Future<bool> verifyOtp(BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _user.otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully")),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      return false;
    }
  }

  // Validate checkbox separately (if needed)
  bool validateCheckbox() => _user.isChecked;
}
