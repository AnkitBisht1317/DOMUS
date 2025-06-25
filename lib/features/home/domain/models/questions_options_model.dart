class Option {
  final String prefix;
  final String text;

  Option({
    required this.prefix,
    required this.text,
  });

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      prefix: map['prefix'] ?? '',
      text: map['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prefix': prefix,
      'text': text,
    };
  }
}
