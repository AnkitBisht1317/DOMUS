import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Private constructor
  UserService._internal();
  
  // Singleton instance
  factory UserService() {
    return _instance;
  }
  
  // Get the current user's name
  Future<String> getCurrentUserName() async {
    try {
      final user = _auth.currentUser;
      if (user?.phoneNumber == null) {
        return "User";
      }
      
      // Get user data from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user!.phoneNumber)
          .get();
      
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Try to get the name from different possible locations in the document
        final data = docSnapshot.data()!;
        
        // Check if fullName exists directly in the document
        if (data.containsKey('fullName') && data['fullName'] != null) {
          return _getFirstName(data['fullName']);
        }
        
        // Check if it's in personalDetails
        if (data.containsKey('personalDetails') && 
            data['personalDetails'] is Map && 
            data['personalDetails']['fullName'] != null) {
          return _getFirstName(data['personalDetails']['fullName']);
        }
      }
      
      // Default fallback
      return "User";
    } catch (e) {
      print('Error getting user name: $e');
      return "User";
    }
  }
  
  // Helper method to get the first name (text before the first space)
  String _getFirstName(String fullName) {
    if (fullName.isEmpty) return "User";
    
    // Split the name by spaces and get the first part
    final nameParts = fullName.trim().split(' ');
    return nameParts.first;
  }
}