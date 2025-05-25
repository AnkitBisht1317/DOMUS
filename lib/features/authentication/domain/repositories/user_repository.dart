import '../models/personal_user_model.dart';
import '../models/student_academic_details.dart';

abstract class UserRepository {
  Future<void> saveUserDetails(UserDetails userDetails);
  Future<UserDetails?> getUserDetails(String phoneNumber);
  Future<void> saveAcademicDetails(String phoneNumber, StudentAcademicDetails academicDetails);
} 