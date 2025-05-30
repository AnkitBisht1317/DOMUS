class QuestionOption {
  final String prefix;
  final String text;

  const QuestionOption({
    required this.prefix,
    required this.text,
  });
}

class QuestionOfDay {
  final String question;
  final String date;
  final List<QuestionOption> options;

  const QuestionOfDay({
    required this.question,
    required this.date,
    required this.options,
  });
} 