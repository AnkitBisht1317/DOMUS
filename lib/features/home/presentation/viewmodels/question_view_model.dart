

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';
import '../screens/qotd_detail_screen.dart';
import '../screens/qotd_explanation_screen.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _questionRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Question? _questionOfDay;
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedOption;
  bool _hasAnswered = false;
  
  Question? get questionOfDay => _questionOfDay;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedOption => _selectedOption;
  bool get hasAnswered => _hasAnswered;

  QuestionViewModel(this._questionRepository) {
    _fetchTodayQuestion();
  }

  /// Fetches the question for today's date and checks if user has already answered
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
        // Check if user has already answered this question
        await _checkUserAnswer(now);
      } else {
        // If no question found for today, try yesterday
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayQuestion = await _questionRepository.getQuestionForDate(yesterday);
        
        if (yesterdayQuestion != null) {
          _questionOfDay = yesterdayQuestion;
          // Check if user has already answered this question
          await _checkUserAnswer(yesterday);
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

  /// Checks if the user has already answered the current question
  Future<void> _checkUserAnswer(DateTime date) async {
    final user = _auth.currentUser;
    if (user == null || _questionOfDay == null) {
      _hasAnswered = false;
      _selectedOption = null;
      notifyListeners();
      return;
    }

    try {
      // Format the date as YYYY-MM-DD for Firestore document ID
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final answerData = await _questionRepository.getUserAnswer(user.phoneNumber!, dateString);

      if (answerData != null) {
        _selectedOption = answerData['selectedOption'];
        _hasAnswered = true;
      } else {
        _hasAnswered = false;
        _selectedOption = null;
      }
      notifyListeners();
    } catch (e) {
      _hasAnswered = false;
      _selectedOption = null;
      notifyListeners();
      debugPrint('Error checking user answer: $e');
    }
  }

  /// Saves the user's answer to Firestore
  Future<void> saveUserAnswer(String selectedOption) async {
    // Set the state immediately to provide instant feedback
    _selectedOption = selectedOption;
    _hasAnswered = true;
    notifyListeners();  // This is crucial - it tells the UI to rebuild
    
    final user = _auth.currentUser;
    if (user == null || _questionOfDay == null) return;

    try {
      // Format the date as YYYY-MM-DD for Firestore document ID
      final dateString = '${_questionOfDay!.date.year}-${_questionOfDay!.date.month.toString().padLeft(2, '0')}-${_questionOfDay!.date.day.toString().padLeft(2, '0')}';
      
      await _questionRepository.saveUserAnswer(
        user.phoneNumber!, 
        dateString, 
        selectedOption, 
        _questionOfDay!.correctOption
      );
    } catch (e) {
      // Even if saving to Firestore fails, we keep the local state updated
      // so the user can still see their selection and access the explanation
      debugPrint('Error saving user answer: $e');
    }
  }

  /// Refreshes the question (can be called when user pulls to refresh)
  Future<void> refreshQuestion() async {
    await _fetchTodayQuestion();
  }

  void explainAnswer(BuildContext context, String? selectedOption) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: QOTDExplanationScreen(selectedOption: selectedOption),
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