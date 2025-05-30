class CourseItem {
  final String title;
  final String subtitle;
  final String price;
  final String discount;
  final String startDate;
  final String endDate;
  final bool isNew;
  final List<String> iconPaths;

  const CourseItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.startDate,
    required this.endDate,
    this.isNew = false,
    this.iconPaths = const ['assets/books.png'],
  });
} 