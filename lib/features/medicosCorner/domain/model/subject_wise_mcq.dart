class SubjectWiseMCQ {
  final String title;
  final String chapter;
  final bool isLocked;
  final int questionCount;

  const SubjectWiseMCQ({
    required this.title,
    required this.chapter,
    this.isLocked = false,
    required this.questionCount,
  });
}
