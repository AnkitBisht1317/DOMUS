class MCQQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int timeSpent; // Time spent on this question in seconds

  const MCQQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.timeSpent = 0,
  });
}

class MCQTest {
  final String title;
  final List<MCQQuestion> questions;
  final int totalTime; // Total time in seconds

  const MCQTest({
    required this.title,
    required this.questions,
    required this.totalTime,
  });
}