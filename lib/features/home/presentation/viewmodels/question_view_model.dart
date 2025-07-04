import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _questionRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Question? _questionOfDay;
  int? _selectedOptionNumber;
  bool _hasAnswered = false;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _userAnswer;

  // Getters
  Question? get questionOfDay => _questionOfDay;
  int? get selectedOptionNumber => _selectedOptionNumber;
  bool get hasAnswered => _hasAnswered;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get the selected option as a string
  String? get selectedOption => _selectedOptionNumber?.toString();

  // Constructor
  QuestionViewModel(this._questionRepository) {
    _fetchTodayQuestion();
  }

  // Fetch today's question
  Future<void> _fetchTodayQuestion() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      print('Fetching question from ALLEN 01 document...');
      // Try to fetch question from ALLEN 01 document
      var question = await _fetchQuestionFromFirestore('ALLEN 01');
      
      if (question != null) {
        print('Question fetched successfully: ${question.question}');
        _questionOfDay = question;
        
        // Check if user has already answered this question
        await _checkUserAnswer();
      } else {
        print('No question available from ALLEN 01');
        _error = 'No question available';
      }
    } catch (e) {
      print('Error fetching question: $e');
      _error = 'Error fetching question: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch question from Firestore
  Future<Question?> _fetchQuestionFromFirestore(String documentId) async {
    try {
      // Use today's date for the question
      final today = DateTime.now();
      
      print('Requesting question from repository for document: $documentId');
      // Fetch the question data from the document
      final questionDoc = await _questionRepository.getQuestionFromDocument(documentId);
      
      if (questionDoc != null) {
        print('Question data received: ${questionDoc.toString()}');
        // Add the date to the question data as a Timestamp
        final questionData = {
          ...questionDoc,
          'date': Timestamp.fromDate(today),  // Convert DateTime to Timestamp
        };
        
        return Question.fromMap(questionData);
      } else {
        print('Repository returned null for document: $documentId');
      }
      
      return null;
    } catch (e) {
      print('Error fetching question from Firestore: $e');
      return null;
    }
  }

  // Check if user has already answered this question
  Future<void> _checkUserAnswer() async {
    if (_questionOfDay == null) return;
    
    try {
      final user = _auth.currentUser;
      if (user == null || user.phoneNumber == null) return;
      
      final phoneNumber = user.phoneNumber!;
      final questionDate = DateFormat('yyyy-MM-dd').format(_questionOfDay!.date);
      
      _userAnswer = await _questionRepository.getUserAnswer(phoneNumber, questionDate);
      
      if (_userAnswer != null && _userAnswer!.containsKey('selectedOption')) {
        _selectedOptionNumber = int.tryParse(_userAnswer!['selectedOption']);
        _hasAnswered = true;
      } else {
        _selectedOptionNumber = null;
        _hasAnswered = false;
      }
      
      notifyListeners();
    } catch (e) {
      print('Error checking user answer: $e');
    }
  }

  // Save user's answer
  // Save user's answer
  Future<void> saveUserAnswer(String optionNumber) async {
    if (_questionOfDay == null) return;
    
    try {
      // Convert option string to int
      final optionInt = int.tryParse(optionNumber);
      if (optionInt == null) return;
      
      // Update local state
      _selectedOptionNumber = optionInt;
      _hasAnswered = true;
      notifyListeners();
      
      // Get user's phone number
      final user = _auth.currentUser;
      final phoneNumber = user?.phoneNumber ?? '+919999999991'; // Use default if not available
      
      // Format the date as required (we'll still use date for storage)
      final questionDate = DateFormat('yyyy-MM-dd').format(_questionOfDay!.date);
      
      // Get the correct option
      final correctOption = _questionOfDay!.answerNr.toString();
      
      // Create the answer data to store
      final answerData = {
        'question': _questionOfDay!.question,
        'selectedOption': optionNumber,
        'correctOption': correctOption,
        'isCorrect': optionInt == _questionOfDay!.answerNr,
        'option1': _questionOfDay!.option1,
        'option2': _questionOfDay!.option2,
        'option3': _questionOfDay!.option3,
        'option4': _questionOfDay!.option4,
        'description': _questionOfDay!.description,
        'activityName': _questionOfDay!.activityName,
        'answeredAt': DateTime.now(),
      };
      
      // Save to Firestore
      await _questionRepository.saveUserAnswer(phoneNumber, questionDate, answerData);
    } catch (e) {
      print('Error saving user answer: $e');
    }
  }

  // Refresh the question
  Future<void> refreshQuestion() async {
    await _fetchTodayQuestion();
  }

  // Navigate to explanation screen
  void explainAnswer(BuildContext context) {
    if (_questionOfDay == null) return;
    
    Navigator.pushNamed(context, '/qotd-explanation', arguments: {
      'question': _questionOfDay,
      'selectedOption': _selectedOptionNumber?.toString(),
    });
  }

  // Navigate to more questions screen
  void showMore(BuildContext context) {
    Navigator.pushNamed(context, '/qotd-detail');
  }
}