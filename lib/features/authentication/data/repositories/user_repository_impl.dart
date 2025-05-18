import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/personal_user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUserDetails(UserDetails userDetails) async {
    try {
      await _firestore.collection('users').doc(userDetails.phoneNumber).set({
        'fullName': userDetails.fullName,
        'phoneNumber': userDetails.phoneNumber,
        'email': userDetails.email,
        'gender': userDetails.gender,
        'dob': userDetails.dob,
        'country': userDetails.country,
        'domicileState': userDetails.domicileState,
        'district': userDetails.district,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  @override
  Future<UserDetails?> getUserDetails(String phoneNumber) async {
    try {
      final doc = await _firestore.collection('users').doc(phoneNumber).get();
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      return UserDetails(
        fullName: data['fullName'] as String,
        phoneNumber: data['phoneNumber'] as String,
        email: data['email'] as String,
        gender: data['gender'] as String,
        dob: data['dob'] as String,
        country: data['country'] as String,
        domicileState: data['domicileState'] as String,
        district: data['district'] as String,
      );
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
  }
} 