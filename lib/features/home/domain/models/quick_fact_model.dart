class QuickFactModel {
  final String title;
  final String description;

  QuickFactModel({required this.title, required this.description});

  // From Firestore
  factory QuickFactModel.fromMap(Map<String, dynamic> data) {
    return QuickFactModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
