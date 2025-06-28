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
      // First create/update the main user document with just the phone number
      await _firestore.collection('users').doc(userDetails.phoneNumber).set({
        'phoneNumber': userDetails.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the personal details document with a fixed ID 'current'
      await _firestore
          .collection('users')
          .doc(userDetails.phoneNumber)
          .collection('personalDetails')
          .doc('current')  // Using a fixed document ID
          .set({          // Using set instead of add
        'fullName': userDetails.fullName,
        'phoneNumber': userDetails.phoneNumber,
        'email': userDetails.email,
        'gender': userDetails.gender,
        'dob': userDetails.dob,
        'country': userDetails.country,
        'domicileState': userDetails.domicileState,
        'district': userDetails.district,
        'profilePhoto': userDetails.profilePhoto, // Added profilePhoto field
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  @override
  Future<UserDetails?> getUserDetails(String phoneNumber) async {
    try {
      // Get the current personal details document
      final docSnapshot = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('personalDetails')
          .doc('current')
          .get();

      if (!docSnapshot.exists) return null;
      
      final data = docSnapshot.data()!;
      return UserDetails(
        fullName: data['fullName'] as String,
        phoneNumber: data['phoneNumber'] as String,
        email: data['email'] as String,
        gender: data['gender'] as String,
        dob: data['dob'] as String,
        country: data['country'] as String,
        domicileState: data['domicileState'] as String,
        district: data['district'] as String,
        profilePhoto: data['profilePhoto'] as String?, // Added profilePhoto retrieval
      );
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
  }

  @override
  Future<void> saveAcademicDetails(String phoneNumber, StudentAcademicDetails academicDetails) async {
    try {
      // Update the academic details document with a fixed ID 'current'
      await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('academicDetails')
          .doc('current')  // Using a fixed document ID
          .set({          // Using set instead of add
        ...academicDetails.toMap(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
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