class MCQQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int timeSpent; // Time spent on this question in seconds
  final String? explanation; // Explanation for the Description tab

  MCQQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.timeSpent = 0,
    this.explanation,
  });
}

class MCQTest {
  final String title;
  List<MCQQuestion> questions; // Made mutable to allow updating questions
  final int totalTime; // Total time in seconds

  MCQTest({
    required this.title,
    required this.questions,
    required this.totalTime,
  });
}