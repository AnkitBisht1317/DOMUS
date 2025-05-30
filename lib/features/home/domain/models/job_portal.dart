class JobPortal {
  final String title;
  final String iconPath;
  final String bannerPath;
  final String? description;

  const JobPortal({
    required this.title,
    required this.iconPath,
    required this.bannerPath,
    this.description,
  });
} 