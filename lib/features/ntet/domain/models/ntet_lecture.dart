class NTETLecture {
  final String title;
  final String chapter;
  final String lectureNumber;
  final String duration;
  final bool isLocked;
  final double progress; // Added progress property

  const NTETLecture({
    required this.title,
    required this.chapter,
    required this.lectureNumber,
    required this.duration,
    this.isLocked = false,
    this.progress = 0.0, // Default progress is 0
  });
}