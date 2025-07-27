class Medico {
  final String title;
  final String imageUrl;

  Medico({required this.title, required this.imageUrl});

  factory Medico.fromMap(Map<String, dynamic> map) {
    return Medico(
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
