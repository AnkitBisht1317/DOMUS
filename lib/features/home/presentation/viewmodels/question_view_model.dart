

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/question_of_day.dart';
import '../screens/qotd_detail_screen.dart';

class QuestionViewModel extends ChangeNotifier {
  QuestionOfDay? _questionOfDay;
  
  QuestionOfDay? get questionOfDay => _questionOfDay;

  QuestionViewModel() {
    _initializeQuestion();
  }

  void _initializeQuestion() {
    _questionOfDay = QuestionOfDay(
      question: 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      date: 'May 04',
      options: [
        QuestionOption(prefix: 'A', text: 'Option A'),
        QuestionOption(prefix: 'B', text: 'Option B'),
        QuestionOption(prefix: 'C', text: 'Option C'),
        QuestionOption(prefix: 'D', text: 'Option D'),
      ],
    );
    notifyListeners();
  }

  void explainAnswer() {
    // Implement answer explanation
  }

  // In the showMore method
  void showMore(BuildContext context) {
    // Navigate to the QOTD detail screen with the current ViewModel instance
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: const QOTDDetailScreen(),
        ),
      ),
    );
  }
}