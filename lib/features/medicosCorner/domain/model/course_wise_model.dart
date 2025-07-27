class CourseWiseModel {
  final String title;
  final String imageUrl;

  CourseWiseModel({required this.title, required this.imageUrl});

  factory CourseWiseModel.fromMap(Map<String, dynamic> map) {
    return CourseWiseModel(
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
