import 'package:provider/provider.dart';
import '../data/repositories/mcq_test_repository_impl.dart';
import '../domain/repositories/mcq_test_repository.dart';
import '../domain/usecases/get_mcq_test_usecase.dart';
import '../domain/usecases/submit_mcq_test_usecase.dart';
import '../domain/usecases/save_mcq_progress_usecase.dart';
import '../presentation/viewmodels/mcq_test_view_model.dart';

/// Dependency injection for MCQ test feature
class MCQTestInjection {
  // Private constructor to prevent instantiation
  MCQTestInjection._();
  
  // Singleton repository instance
  static final MCQTestRepository _repository = MCQTestRepositoryImpl();
  
  // Use cases
  static final GetMCQTestUseCase _getMCQTestUseCase = GetMCQTestUseCase(_repository);
  
  static final SubmitMCQTestUseCase _submitMCQTestUseCase = SubmitMCQTestUseCase(_repository);
  
  static final SaveMCQProgressUseCase _saveMCQProgressUseCase = SaveMCQProgressUseCase(_repository);
  
  // Provider list for MultiProvider
  static final List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<MCQTestViewModel>(
      create: (context) => MCQTestViewModel(
        _getMCQTestUseCase,
        _submitMCQTestUseCase,
        _saveMCQProgressUseCase,
      ),
    ),
  ];
}