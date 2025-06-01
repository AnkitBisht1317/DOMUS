import 'dart:ui';

enum CategoryType {
  all,
  exam,
  study,
  revision,
  community
}

class CategoryIcon {
  final String title;
  final String imagePath;
  final double fontSize;
  final VoidCallback? onTap;
  final List<CategoryType> categories;

  const CategoryIcon({
    required this.title,
    required this.imagePath,
    this.fontSize = 12,
    this.onTap,
    required this.categories,
  });

  bool belongsToCategory(CategoryType category) {
    return category == CategoryType.all || categories.contains(category);
  }
} 