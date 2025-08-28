import '../../domain/models/mcq_test_model.dart';
import '../../domain/repositories/mcq_test_repository.dart';

class MCQTestRepositoryImpl implements MCQTestRepository {
  // Sample data for demonstration
  final Map<String, MCQTest> _tests = {
    'Physics Chapter 1': MCQTest(
      title: 'Physics Chapter 1',
      totalTime: 3600, // 60 minutes
      questions: [
        MCQQuestion(
          question: 'Preload measures ?',
          options: [
            'End Systolic volume',
            'End diastolic volume',
            'Peripheral resistance',
            'Stroke volume',
          ],
          correctAnswer: 1,
        ),
        MCQQuestion(
          question: 'Which of the following is a characteristic of homeopathic remedies?',
          options: [
            'They are always administered in high doses',
            'They follow the principle of "like cures like"',
            'They are primarily derived from synthetic chemicals',
            'They are designed to suppress symptoms',
          ],
          correctAnswer: 1,
        ),
        MCQQuestion(
          question: 'What is the significance of potentization in homeopathy?',
          options: [
            'It increases the toxicity of the remedy',
            'It enhances the healing properties while reducing side effects',
            'It makes remedies more affordable to produce',
            'It extends the shelf life of remedies',
          ],
          correctAnswer: 1,
        ),
      ],
    ),
    'Physics Chapter 1 Mock Test Series.': MCQTest(
      title: 'Physics Chapter 1 Mock Test Series.',
      totalTime: 3600, // 60 minutes
      questions: [
        MCQQuestion(
          question: 'What is the SI unit of force?',
          options: [
            'Watt',
            'Newton',
            'Joule',
            'Pascal',
          ],
          correctAnswer: 1,
        ),
        MCQQuestion(
          question: 'Which law states that for every action, there is an equal and opposite reaction?',
          options: [
            'Newton\'s First Law',
            'Newton\'s Second Law',
            'Newton\'s Third Law',
            'Law of Conservation of Energy',
          ],
          correctAnswer: 2,
        ),
        MCQQuestion(
          question: 'What is the formula for kinetic energy?',
          options: [
            'KE = mgh',
            'KE = 1/2 mv²',
            'KE = Fd',
            'KE = P/t',
          ],
          correctAnswer: 1,
        ),
      ],
    ),
    'Physics Chapter 2 Mock Test Series.': MCQTest(
      title: 'Physics Chapter 2 Mock Test Series.',
      totalTime: 3600, // 60 minutes
      questions: [
        MCQQuestion(
          question: 'What is the unit of electric current?',
          options: [
            'Volt',
            'Ampere',
            'Ohm',
            'Coulomb',
          ],
          correctAnswer: 1,
        ),
        MCQQuestion(
          question: 'Which law relates the current through a conductor to the voltage across it?',
          options: [
            'Faraday\'s Law',
            'Ohm\'s Law',
            'Coulomb\'s Law',
            'Ampere\'s Law',
          ],
          correctAnswer: 1,
        ),
        MCQQuestion(
          question: 'What is the formula for electrical power?',
          options: [
            'P = VI',
            'P = V/I',
            'P = I²R',
            'Both A and C',
          ],
          correctAnswer: 3,
        ),
      ],
    ),
  };

  @override
  Future<MCQTest> getTest(String title) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_tests.containsKey(title)) {
      return _tests[title]!;
    } else {
      throw Exception('Test not found');
    }
  }

  @override
  Future<void> submitTest(String testId, List<int> answers, List<int> timeSpent) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would send the answers to a backend
    print('Test $testId submitted with answers: $answers and time spent: $timeSpent');
    return;
  }

  @override
  Future<void> saveProgress(String testId, int currentQuestionIndex, int selectedAnswerIndex) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would save progress to local storage or backend
    print('Progress saved for test $testId: question $currentQuestionIndex, answer $selectedAnswerIndex');
    return;
  }
}