import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domus/features/home/domain/models/questions_options_model.dart';

class Question {
  final String correctOption;
  final DateTime date;
  final String description;
  final List<Option> options;
  final String question;

  Question({
    required this.correctOption,
    required this.date,
    required this.description,
    required this.options,
    required this.question,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    var optionsFromMap = map['options'] as List<dynamic>? ?? [];
    List<Option> optionsList = optionsFromMap
        .map((optionMap) => Option.fromMap(optionMap as Map<String, dynamic>))
        .toList();

    // Convert Firestore Timestamp to DateTime
    DateTime dateTime;
    if (map['date'] is Timestamp) {
      dateTime = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      dateTime = map['date'];
    } else {
      dateTime = DateTime.now(); // fallback
    }

    return Question(
      correctOption: map['correctOption'] ?? '',
      date: dateTime,
      description: map['description'] ?? '',
      options: optionsList,
      question: map['question'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correctOption': correctOption,
      'date': Timestamp.fromDate(date),
      'description': description,
      'options': options.map((option) => option.toMap()).toList(),
      'question': question,
    };
  }
}
