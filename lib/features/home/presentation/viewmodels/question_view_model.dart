

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';
import '../screens/qotd_detail_screen.dart';
import '../screens/qotd_explanation_screen.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _questionRepository;
  Question? _questionOfDay;
  bool _isLoading = false;
  String? _errorMessage;
  
  Question? get questionOfDay => _questionOfDay;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  QuestionViewModel(this._questionRepository) {
    _fetchTodayQuestion();
  }

  /// Fetches the question for today's date
  Future<void> _fetchTodayQuestion() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Get current local date
      final now = DateTime.now();
      
      // Fetch question for today
      final question = await _questionRepository.getQuestionForDate(now);
      
      if (question != null) {
        _questionOfDay = question;
      } else {
        // If no question found for today, try yesterday
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayQuestion = await _questionRepository.getQuestionForDate(yesterday);
        
        if (yesterdayQuestion != null) {
          _questionOfDay = yesterdayQuestion;
        } else {
          _errorMessage = 'No question available';
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load question: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the question (can be called when user pulls to refresh)
  Future<void> refreshQuestion() async {
    await _fetchTodayQuestion();
  }

  void explainAnswer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: const QOTDExplanationScreen(),
        ),
      ),
    );
  }

  void showMore(BuildContext context) {
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