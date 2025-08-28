import '../models/mcq_test_model.dart';

abstract class MCQTestRepository {
  // Get a test by its ID or other identifier
  Future<MCQTest> getTest(String title);
  
  // Submit answers for a test
  Future<void> submitTest(String testId, List<int> answers, List<int> timeSpent);
  
  // Save progress for a test
  Future<void> saveProgress(String testId, int currentQuestionIndex, int selectedAnswerIndex);
}