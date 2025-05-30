import 'package:flutter/foundation.dart';
import '../../domain/models/question_of_day.dart';

class QuestionViewModel extends ChangeNotifier {
  QuestionOfDay? _questionOfDay;
  
  QuestionOfDay? get questionOfDay => _questionOfDay;

  QuestionViewModel() {
    _initializeQuestion();
  }

  void _initializeQuestion() {
    _questionOfDay = QuestionOfDay(
      question: 'Who is the current Pradhan Mantri Of INDIA ?',
      date: 'May 26',
      options: [
        QuestionOption(prefix: 'A', text: 'Amit Shah'),
        QuestionOption(prefix: 'B', text: 'Jatin Shah'),
        QuestionOption(prefix: 'C', text: 'Narendra Modi'),
        QuestionOption(prefix: 'D', text: 'Nirav Modi'),
      ],
    );
    notifyListeners();
  }

  void explainAnswer() {
    // Implement answer explanation
  }

  void showMore() {
    // Implement show more functionality
  }
} 