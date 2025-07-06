import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _questionRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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
        
        // Try to fetch answer stats from the database document's questions array
        Map<String, dynamic>? answerStats;
        try {
          final docSnapshot = await _firestore
              .collection('database')
              .doc(questionDoc['activityName'])
              .get();
              
          if (docSnapshot.exists) {
            print('Document data: ${docSnapshot.data()}');
            
            // Check for both "Questions" and "questions" field names
            String questionsField = 'Questions'; // Try the capitalized version first
            if (!docSnapshot.data()!.containsKey(questionsField)) {
              questionsField = 'questions'; // Try lowercase if capitalized doesn't exist
              if (!docSnapshot.data()!.containsKey(questionsField)) {
                print('Neither "Questions" nor "questions" field found in document');
                return Question.fromMap({
                  ...questionDoc,
                  'date': Timestamp.fromDate(today),
                });
              }
            }
            
            List<dynamic> questions = List.from(docSnapshot.data()![questionsField]);
            print('Found ${questions.length} questions in the array using field "$questionsField"');
            
            // Find the question in the array
            for (var question in questions) {
              if (question['question'] == questionDoc['question']) {
                print('Found matching question: ${question['question']}');
                if (question.containsKey('answerStats')) {
                  answerStats = Map<String, dynamic>.from(question['answerStats']);
                  print('Found answer stats: $answerStats');
                } else {
                  print('No answer stats found for this question');
                }
                break;
              }
            }
          }
        } catch (e) {
          print('Error fetching answer stats: $e');
        }
        
        // Add the date and answer stats to the question data
        final questionData = {
          ...questionDoc,
          'date': Timestamp.fromDate(today),
          if (answerStats != null) 'answerStats': answerStats,
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
      
      // Update answer statistics in the database
      await _updateAnswerStats(optionNumber);
    } catch (e) {
      print('Error saving user answer: $e');
    }
  }
  
  // Update answer statistics in the database collection
  // Update answer statistics directly in the database document's questions array
  Future<void> _updateAnswerStats(String selectedOption) async {
    try {
      if (_questionOfDay == null) return;
      
      final activityName = _questionOfDay!.activityName;
      print('Updating answer stats for question: ${_questionOfDay!.question}');
      print('Activity name: $activityName');
      
      // Get a reference to the database document
      final docRef = _firestore.collection('database').doc(activityName);
      
      // Run a transaction to safely update the document
      await _firestore.runTransaction((transaction) async {
        // Get the current document
        final docSnapshot = await transaction.get(docRef);
        
        if (!docSnapshot.exists) {
          print('Activity document not found: $activityName');
          return;
        }
        
        print('Document data: ${docSnapshot.data()}');
        
        // Check for both lowercase and uppercase field names
        String questionsField = 'Questions'; // Try the capitalized version first
        if (!docSnapshot.data()!.containsKey(questionsField)) {
          questionsField = 'questions'; // Try lowercase if capitalized doesn't exist
          if (!docSnapshot.data()!.containsKey(questionsField)) {
            print('Neither "Questions" nor "questions" field found in document');
            return;
          }
        }
        
        // Get the questions array
        List<dynamic> questions = List.from(docSnapshot.data()![questionsField]);
        print('Found ${questions.length} questions in the array using field "$questionsField"');
        
        // Find the index of the current question
        int questionIndex = -1;
        for (int i = 0; i < questions.length; i++) {
          if (questions[i]['question'] == _questionOfDay!.question) {
            questionIndex = i;
            print('Found question at index $i');
            break;
          }
        }
        
        if (questionIndex == -1) {
          print('Question not found in the array: ${_questionOfDay!.question}');
          return;
        }
        
        // Get or initialize answer stats
        Map<String, dynamic> answerStats = {};
        if (questions[questionIndex].containsKey('answerStats')) {
          answerStats = Map<String, dynamic>.from(questions[questionIndex]['answerStats']);
          print('Existing answer stats: $answerStats');
        } else {
          print('Initializing new answer stats');
          answerStats = {
            'Total Answered': 0,
            'option1 selected': 0,
            'option2 selected': 0,
            'option3 selected': 0,
            'option4 selected': 0,
            // Initialize option5 counter only if option5 exists and is not empty
            if (_questionOfDay!.option5.isNotEmpty) 'option5 selected': 0,
          };
        }
        
        // Update the stats
        answerStats['Total Answered'] = (answerStats['Total Answered'] ?? 0) + 1;
        
        // Increment the selected option counter
        final optionKey = 'option$selectedOption selected';
        answerStats[optionKey] = (answerStats[optionKey] ?? 0) + 1;
        
        print('Updated answer stats: $answerStats');
        
        // Update the question in the array
        questions[questionIndex]['answerStats'] = answerStats;
        
        // Update the document with the modified questions array
        transaction.update(docRef, {questionsField: questions});
        print('Transaction completed successfully');
      });
      
      // Fetch the updated question to refresh the UI
      await _fetchTodayQuestion();
    } catch (e) {
      print('Error updating answer stats: $e');
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