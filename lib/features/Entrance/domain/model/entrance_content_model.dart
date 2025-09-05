class EntranceContent {
  final String title;
  final String? subtitle;
  final String? source;
  final String? imageUrl;
  final bool isUnlocked;

  EntranceContent({
    required this.title,
    this.subtitle,
    this.source,
    this.imageUrl,
    this.isUnlocked = false,
  });
}

class EntranceContentCollection {
  final List<EntranceContent> lectures;
  final List<EntranceContent> notes;
  final List<EntranceContent> mcqs;

  EntranceContentCollection({
    required this.lectures,
    required this.notes,
    required this.mcqs,
  });
}