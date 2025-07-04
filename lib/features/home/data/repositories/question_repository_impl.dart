import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Track the current position in the sequence
  int _currentSequenceIndex = 0;
  int _currentQuestionIndex = 0;
  List<String> _activitySequence = [];
  Map<String, int> _activityQuestionCounts = {};

  // Initialize the sequence
  Future<void> _initializeSequence() async {
    try {
      final sequenceDoc = await _firestore.collection('QOTDQuestions').doc('QuestionsSequence').get();
      
      if (sequenceDoc.exists && sequenceDoc.data() != null) {
        final data = sequenceDoc.data()!;
        if (data.containsKey('sequence') && data['sequence'] is List) {
          _activitySequence = List<String>.from(data['sequence']);
          
          // Initialize question counts for each activity
          for (final activityName in _activitySequence) {
            final querySnapshot = await _firestore
                .collection('database')
                .doc(activityName)
                .collection('questions')
                .get();
            
            _activityQuestionCounts[activityName] = querySnapshot.docs.length;
          }
        }
      }
    } catch (e) {
      print('Error initializing sequence: $e');
    }
  }

  @override
  Future<Question?> getQuestionForDate(DateTime date) async {
    try {
      // Initialize sequence if needed
      if (_activitySequence.isEmpty) {
        await _initializeSequence();
      }
      
      if (_activitySequence.isEmpty) {
        return null; // No sequence available
      }

      // Format the date as YYYY-MM-DD for Firestore document ID
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Check if we already have a question for this date
      final existingQuestion = await _firestore.collection('QOTD').doc(dateString).get();
      
      if (existingQuestion.exists && existingQuestion.data() != null) {
        // If we already have a question for this date, return it
        final questionData = existingQuestion.data()!;
        questionData['date'] = Timestamp.fromDate(date); // Ensure date is set
        return Question.fromMap(questionData);
      }
      
      // Get the current activity from the sequence
      String currentActivity = _activitySequence[_currentSequenceIndex];
      
      // Check if we need to skip this activity (no questions left)
      while (_currentQuestionIndex >= (_activityQuestionCounts[currentActivity] ?? 0)) {
        // Move to the next activity
        _currentSequenceIndex = (_currentSequenceIndex + 1) % _activitySequence.length;
        
        // If we've completed a full cycle, increment the question index
        if (_currentSequenceIndex == 0) {
          _currentQuestionIndex++;
        }
        
        currentActivity = _activitySequence[_currentSequenceIndex];
      }
      
      // Query the database collection for the current activity
      final querySnapshot = await _firestore
          .collection('database')
          .doc(currentActivity)
          .collection('questions')
          .where('questionNr', isEqualTo: _currentQuestionIndex + 1) // 1-based indexing
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final questionDoc = querySnapshot.docs.first;
        final questionData = questionDoc.data();
        
        // Add the activity name and date to the question data
        questionData['activityName'] = currentActivity;
        questionData['date'] = Timestamp.fromDate(date);
        
        // Save this question to QOTD collection for this date
        await _firestore.collection('QOTD').doc(dateString).set(questionData);
        
        // Move to the next activity in the sequence
        _currentSequenceIndex = (_currentSequenceIndex + 1) % _activitySequence.length;
        
        // If we've completed a full cycle, increment the question index
        if (_currentSequenceIndex == 0) {
          _currentQuestionIndex++;
        }
        
        return Question.fromMap(questionData);
      }
      
      return null;
    } catch (e) {
      print('Error fetching question: $e');
      return null;
    }
  }
  
  
  // Remove the duplicate saveUserAnswer method (lines 121-135)
  
  @override
  Future<Map<String, dynamic>?> getUserAnswer(String phoneNumber, String questionDate) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('quizData')
          .doc('qotd')
          .collection('answers')
          .doc(questionDate)
          .get();
          
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      
      return null;
    } catch (e) {
      print('Error getting user answer: $e');
      return null;
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getQuestionFromDocument(String documentId) async {
    try {
      // Fetch the document containing the questions array
      final docSnapshot = await _firestore.collection('database').doc(documentId).get();
      
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        
        // Check for both lowercase and uppercase field names
        List<dynamic> questions = [];
        
        if (data.containsKey('questions') && data['questions'] is List) {
          questions = List<dynamic>.from(data['questions']);
        } else if (data.containsKey('Questions') && data['Questions'] is List) {
          questions = List<dynamic>.from(data['Questions']);
        }
        
        // If there are questions, return the first one
        if (questions.isNotEmpty) {
          // Make sure we're handling the question data correctly
          final questionData = Map<String, dynamic>.from(questions[0]);
          
          // Add the activity name if it's not already there
          if (!questionData.containsKey('activityName')) {
            questionData['activityName'] = documentId;
          }
          
          print('Found question: ${questionData['question']}');
          return questionData;
        } else {
          print('No questions found in the array');
        }
      } else {
        print('Document does not exist or has no data');
      }
      
      return null;
    } catch (e) {
      print('Error fetching question from document: $e');
      return null;
    }
  }
  
  @override
  Future<void> saveUserAnswer(String phoneNumber, String questionDate, Map<String, dynamic> answerData) async {
    try {
      await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('quizData')
          .doc('qotd')
          .collection('answers')
          .doc(questionDate)
          .set(answerData);
    } catch (e) {
      print('Error saving user answer: $e');
    }
  }
}