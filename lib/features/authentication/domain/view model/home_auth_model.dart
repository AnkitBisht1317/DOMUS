import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/home_user_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserModel _user = UserModel(phoneNumber: '', otp: '', isChecked: false);
  String? _verificationId;
  bool _otpSent = false;
  bool _isLoading = false;

  // Getters
  String get phoneNumber => _user.phoneNumber;
  String get otp => _user.otp;
  bool get isChecked => _user.isChecked;
  bool get otpSent => _otpSent;
  bool get isLoading => _isLoading;

  // Setters
  void setPhoneNumber(String phone) {
    // Ensure phone number is in E.164 format for Firestore
    _user.phoneNumber = phone.startsWith('+') ? phone : '+$phone';
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
    if (_user.phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    _isLoading = true;
    _otpSent = false;
    notifyListeners();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _user.phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          await _signInWithCredential(credential, context);
        },
        verificationFailed: (FirebaseAuthException e) {
          _handleError(e, context);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _otpSent = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent successfully!")),
          );
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          notifyListeners();
        },
      );
    } catch (e) {
      _handleError(e, context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(BuildContext context) async {
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please request OTP first")),
      );
      return false;
    }

    if (_user.otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _user.otp,
      );

      return await _signInWithCredential(credential, context);
    } catch (e) {
      _handleError(e, context);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _signInWithCredential(
    PhoneAuthCredential credential,
    BuildContext context,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      _handleError(e, context);
      return false;
    }
  }

  void _handleError(dynamic error, BuildContext context) {
    String message = "An error occurred";
    if (error is FirebaseAuthException) {
      message = error.message ?? "Authentication error occurred";
    } else if (error is Exception) {
      message = error.toString();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Sign out method
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Validate checkbox separately
  bool validateCheckbox() => _user.isChecked;
}
