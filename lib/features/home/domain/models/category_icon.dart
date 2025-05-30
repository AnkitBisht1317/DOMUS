import 'dart:ui';

class CategoryIcon {
  final String title;
  final String imagePath;
  final double fontSize;
  final VoidCallback? onTap;

  const CategoryIcon({
    required this.title,
    required this.imagePath,
    this.fontSize = 12,
    this.onTap,
  });
} 