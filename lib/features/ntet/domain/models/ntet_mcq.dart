class NTETMCQ {
  final String title;
  final String chapter;
  final bool isLocked;
  final int questionCount;

  const NTETMCQ({
    required this.title,
    required this.chapter,
    this.isLocked = false,
    required this.questionCount,
  });
}