import '../../domain/models/question_of_day.dart';

abstract class QuestionRepository {
  /// Fetches a question for the specified date from Firestore
  /// Returns null if no question is found
  Future<Question?> getQuestionForDate(DateTime date);
}