import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/question_of_day.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Question?> getQuestionForDate(DateTime date) async {
    try {
      // Format the date as YYYY-MM-DD for Firestore document ID
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Query the QOTD collection with the formatted date
      final docSnapshot = await _firestore.collection('QOTD').doc(dateString).get();
      
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Convert the Firestore document to a Question object
        return Question.fromMap(docSnapshot.data()!);
      }
      
      // If no question found for today, return null
      return null;
    } catch (e) {
      print('Error fetching question: $e');
      return null;
    }
  }
  
  @override
  Future<void> saveUserAnswer(String phoneNumber, String questionDate, String selectedOption, String correctOption) async {
    try {
      await _firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('quizData')
          .doc('qotd')
          .collection('answers')
          .doc(questionDate)
          .set({
        'selectedOption': selectedOption,
        'correctOption': correctOption,
        'answeredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving user answer: $e');
    }
  }
  
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
}