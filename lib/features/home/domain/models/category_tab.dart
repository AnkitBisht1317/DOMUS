import 'category_icon.dart';

class CategoryTab {
  final CategoryType type;
  final String title;
  final bool isSelected;

  const CategoryTab({
    required this.type,
    required this.title,
    this.isSelected = false,
  });

  CategoryTab copyWith({
    CategoryType? type,
    String? title,
    bool? isSelected,
  }) {
    return CategoryTab(
      type: type ?? this.type,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }
} 