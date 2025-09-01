import 'package:provider/provider.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_user_info_usecase.dart';
import '../presentation/viewmodels/user_view_model.dart';

/// Dependency injection for User feature
class UserInjection {
  // Private constructor to prevent instantiation
  UserInjection._();
  
  // Singleton repository instance
  static final UserRepository _repository = UserRepositoryImpl();
  
  // Use cases
  static final GetUserInfoUseCase _getUserInfoUseCase = GetUserInfoUseCase(_repository);
  
  // Map to store attempt counts for each test
  static final Map<String, int> _testAttempts = {};
  
  // Get and increment attempt count for a test
  static int getUserAttemptCount(String testTitle) {
    if (!_testAttempts.containsKey(testTitle)) {
      _testAttempts[testTitle] = 0;
    }
    _testAttempts[testTitle] = _testAttempts[testTitle]! + 1;
    return _testAttempts[testTitle]!;
  }
  
  // Provider list for MultiProvider
  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<UserViewModel>(
      create: (context) => UserViewModel(_getUserInfoUseCase),
    ),
  ];
}