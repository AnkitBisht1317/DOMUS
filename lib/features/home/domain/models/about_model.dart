class AboutModel {
  final String paragraph;

  AboutModel({required this.paragraph});

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    return AboutModel(paragraph: map['paragraph'] ?? '');
  }
}
