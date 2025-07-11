import '../../domain/models/question_of_day.dart';

abstract class QuestionRepository {
  /// Fetches a question for the specified date from Firestore
  /// Returns null if no question is found
  
  /// Fetches a question from a specific document ID
  Future<Map<String, dynamic>?> getQuestionFromDocument(String documentId);
  
  /// Saves the user's answer to a question
  Future<void> saveUserAnswer(String phoneNumber, String questionDate, Map<String, dynamic> answerData);
  
  /// Gets the user's answer for a specific question
  Future<Map<String, dynamic>?> getUserAnswer(String phoneNumber, String questionDate);
  
  Future<Question?> getTodayQuestion();
}