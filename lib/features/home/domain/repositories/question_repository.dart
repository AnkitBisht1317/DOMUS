import '../../domain/models/question_of_day.dart';

abstract class QuestionRepository {
  /// Fetches a question for the specified date from Firestore
  /// Returns null if no question is found
  Future<Question?> getQuestionForDate(DateTime date);
  
  /// Saves the user's answer to a question
  Future<void> saveUserAnswer(String phoneNumber, String questionDate, String selectedOption, String correctOption);
  
  /// Gets the user's answer for a specific question
  Future<Map<String, dynamic>?> getUserAnswer(String phoneNumber, String questionDate);
}