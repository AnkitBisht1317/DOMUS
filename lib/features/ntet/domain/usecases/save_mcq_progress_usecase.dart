import '../repositories/mcq_test_repository.dart';

class SaveMCQProgressUseCase {
  final MCQTestRepository repository;

  SaveMCQProgressUseCase(this.repository);

  Future<void> execute(String testId, int currentQuestionIndex, int selectedAnswerIndex) async {
    return await repository.saveProgress(testId, currentQuestionIndex, selectedAnswerIndex);
  }
}