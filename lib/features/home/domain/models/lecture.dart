class Lecture {
  final String title;
  final String duration;
  final String imagePath;
  final double progress;

  const Lecture({
    required this.title,
    required this.duration,
    required this.imagePath,
    this.progress = 0.0,
  });
} 