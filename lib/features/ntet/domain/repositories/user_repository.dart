import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserInfo> getUserInfo();
}