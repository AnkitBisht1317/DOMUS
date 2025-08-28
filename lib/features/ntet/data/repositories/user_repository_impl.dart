import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // In-memory storage for user info
  static String _userName = 'Dr. Ankit';
  static String _userId = '1';
  
  @override
  Future<UserInfo> getUserInfo() async {
    // In a real app, this would fetch from an API or local database
    // For now, we'll use a simple in-memory approach
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return UserInfo(name: _userName, id: _userId);
  }
  
  // Method to update user info (not used in this implementation but could be useful)
  Future<void> updateUserInfo(String name, String id) async {
    _userName = name;
    _userId = id;
  }
}