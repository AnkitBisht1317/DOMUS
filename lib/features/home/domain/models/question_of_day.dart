import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String activityName;
  final int answerNr;
  final String description;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String option5;
  final String question;
  final DateTime date;
  final Map<String, dynamic>? answerStats; // Stores answer statistics

  Question({
    required this.activityName,
    required this.answerNr,
    required this.description,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.option5,
    required this.question,
    required this.date,
    this.answerStats,
  });

  // Get the correct option text based on the answer number
  String get correctOptionText {
    switch (answerNr) {
      case 1: return option1;
      case 2: return option2;
      case 3: return option3;
      case 4: return option4;
      case 5: return option5.isNotEmpty ? option5 : '';
      default: return '';
    }
  }

  // Create a Question from a Firestore document
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      activityName: map['activityName'] ?? '',
      answerNr: map['answerNr'] ?? 1,
      description: map['description'] ?? '',
      option1: map['option1'] ?? '',
      option2: map['option2'] ?? '',
      option3: map['option3'] ?? '',
      option4: map['option4'] ?? '',
      option5: map['option5'] ?? '',
      question: map['question'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      answerStats: map['answerStats'] as Map<String, dynamic>?,
    );
  }

  // Convert Question to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'answerNr': answerNr,
      'description': description,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'option5': option5,
      'question': question,
      'date': Timestamp.fromDate(date),
      if (answerStats != null) 'answerStats': answerStats,
    };
  }
}
