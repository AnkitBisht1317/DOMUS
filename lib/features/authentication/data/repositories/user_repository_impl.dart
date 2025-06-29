import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/personal_user_model.dart';
import '../../domain/models/student_academic_details.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUserDetails(UserDetails userDetails) async {
    try {
      // Create/update the main user document with personal details as a map
      await _firestore.collection('users').doc(userDetails.phoneNumber).set({
        'phoneNumber': userDetails.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'personalDetails': {
          'fullName': userDetails.fullName,
          'email': userDetails.email,
          'gender': userDetails.gender,
          'dob': userDetails.dob,
          'country': userDetails.country,
          'domicileState': userDetails.domicileState,
          'district': userDetails.district,
          'lastUpdated': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  @override
  @override
  Future<UserDetails?> getUserDetails(String phoneNumber) async {
    try {
      // Get the main user document
      final docSnapshot = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();
  
      if (!docSnapshot.exists || docSnapshot.data()?['personalDetails'] == null) return null;
      
      final personalData = docSnapshot.data()!['personalDetails'] as Map<String, dynamic>;
      return UserDetails(
        fullName: personalData['fullName'] as String,
        phoneNumber: phoneNumber,
        email: personalData['email'] as String,
        gender: personalData['gender'] as String,
        dob: personalData['dob'] as String,
        country: personalData['country'] as String,
        domicileState: personalData['domicileState'] as String,
        district: personalData['district'] as String,
      );
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
  }

  @override
  Future<void> saveAcademicDetails(String phoneNumber, StudentAcademicDetails academicDetails) async {
    try {
      // Update the main user document with academic details as a map
      await _firestore
          .collection('users')
          .doc(phoneNumber)
          .set({
        'academicDetails': {
          'batch': academicDetails.batch,
          'collegeState': academicDetails.collegeState,
          'collegeName': academicDetails.collegeName,
          'timestamp': academicDetails.timestamp,
          'lastUpdated': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save academic details: $e');
    }
  }
  
  @override
  Future<void> saveFcmToken(String phoneNumber, String fcmToken) async {
    try {
      // Store the FCM token directly in the user document
      await _firestore.collection('users').doc(phoneNumber).update({
        'fcmToken': fcmToken,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save FCM token: $e');
    }
  }
}