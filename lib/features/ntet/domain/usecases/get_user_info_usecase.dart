import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository _repository;

  GetUserInfoUseCase(this._repository);

  Future<UserInfo> execute() async {
    return await _repository.getUserInfo();
  }
}