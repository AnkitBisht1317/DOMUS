import '../repositories/mcq_test_repository.dart';

class SubmitMCQTestUseCase {
  final MCQTestRepository repository;

  SubmitMCQTestUseCase(this.repository);

  Future<void> execute(String testId, List<int> answers, List<int> timeSpent) async {
    return await repository.submitTest(testId, answers, timeSpent);
  }
}