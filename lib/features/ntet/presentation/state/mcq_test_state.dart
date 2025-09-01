import '../../domain/models/mcq_test_model.dart';

// State class for MCQ test
class MCQTestState {
  final bool isLoading;
  final String? error;
  final MCQTest? test;
  final int currentQuestionIndex;
  final int selectedAnswerIndex;
  final int remainingTime;
  final List<int> timeSpent;
  final List<int> selectedAnswers;
  final double fontSize;
  final String selectedLanguage;
  final DateTime? startTime;
  final DateTime? endTime;
  final int attemptCount;

  const MCQTestState({
    this.isLoading = false,
    this.error,
    this.test,
    this.currentQuestionIndex = 0,
    this.selectedAnswerIndex = -1,
    this.remainingTime = 3600, // 60 minutes in seconds
    this.timeSpent = const [],
    this.selectedAnswers = const [],
    this.fontSize = 16.0,
    this.selectedLanguage = 'English',
    this.startTime,
    this.endTime,
    this.attemptCount = 0,
  });

  // Create a copy of the state with updated values
  MCQTestState copyWith({
    bool? isLoading,
    String? error,
    MCQTest? test,
    int? currentQuestionIndex,
    int? selectedAnswerIndex,
    int? remainingTime,
    List<int>? timeSpent,
    List<int>? selectedAnswers,
    double? fontSize,
    String? selectedLanguage,
    DateTime? startTime,
    DateTime? endTime,
    int? attemptCount,
  }) {
    return MCQTestState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      test: test ?? this.test,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      timeSpent: timeSpent ?? this.timeSpent,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      attemptCount: attemptCount ?? this.attemptCount,
      fontSize: fontSize ?? this.fontSize,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  // Reset error state
  MCQTestState clearError() {
    return copyWith(error: null);
  }

  // Check if the test is loaded
  bool get isTestLoaded => test != null;

  // Get the current question
  MCQQuestion get currentQuestion => test!.questions[currentQuestionIndex];

  // Check if the current question has an answer selected
  bool get hasSelectedAnswer => selectedAnswerIndex != -1;

  // Check if it's the first question
  bool get isFirstQuestion => currentQuestionIndex == 0;

  // Check if it's the last question
  bool get isLastQuestion => currentQuestionIndex == test!.questions.length - 1;
}