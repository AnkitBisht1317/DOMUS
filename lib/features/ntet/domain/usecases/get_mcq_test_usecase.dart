import '../models/mcq_test_model.dart';
import '../repositories/mcq_test_repository.dart';

class GetMCQTestUseCase {
  final MCQTestRepository repository;

  GetMCQTestUseCase(this.repository);

  Future<MCQTest> execute(String title) async {
    return await repository.getTest(title);
  }
}