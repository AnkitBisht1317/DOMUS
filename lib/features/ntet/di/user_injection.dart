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
  
  // Provider list for MultiProvider
  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<UserViewModel>(
      create: (context) => UserViewModel(_getUserInfoUseCase),
    ),
  ];
}