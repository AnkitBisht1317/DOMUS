import '../models/personal_user_model.dart';

abstract class UserRepository {
  Future<void> saveUserDetails(UserDetails userDetails);
  Future<UserDetails?> getUserDetails(String phoneNumber);
} 