class CategoryTab {
  final String title;
  final bool isSelected;

  const CategoryTab({
    required this.title,
    this.isSelected = false,
  });

  CategoryTab copyWith({
    String? title,
    bool? isSelected,
  }) {
    return CategoryTab(
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }
} 