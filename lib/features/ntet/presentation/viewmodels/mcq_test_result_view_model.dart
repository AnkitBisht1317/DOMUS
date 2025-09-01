import 'package:domus/features/ntet/domain/models/mcq_test_model.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class MCQTestResultViewModel extends ChangeNotifier {
  final MCQTest test;
  final List<int> selectedAnswers;
  final int totalTimeSpent;
  final UserService _userService = UserService();
  
  // User info
  String userName = "User";
  int rank = 65;
  int attemptNumber = 1; // Default to 1st attempt if not specified
  
  // Calculated values
  late int correctAnswers;
  late int incorrectAnswers;
  late int unansweredQuestions;
  late int totalQuestions;
  late double percentageScore;
  late String formattedTime;
  late int marksObtained;
  late int totalMarks;
  
  // Time tracking
  late DateTime startTime;
  late DateTime endTime;
  
  // Mock leaderboard data
  final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Dr.Ankit\'s', 'score': '00', 'rank': '!!'},
    {'name': 'Cody Fisher', 'score': '325', 'rank': '1'},
    {'name': 'Albert Flores', 'score': '300', 'rank': '2'},
    {'name': 'Robert Fox', 'score': '298', 'rank': '3'},
    {'name': 'Darrell Steward', 'score': '292', 'rank': '4'},
  ];

  MCQTestResultViewModel({
    required this.test,
    required this.selectedAnswers,
    required this.totalTimeSpent,
    DateTime? startTime,
    DateTime? endTime,
    int attemptNumber = 0,
  }) {
    // Use provided values or defaults
    this.startTime = startTime ?? DateTime.now().subtract(Duration(seconds: totalTimeSpent));
    this.endTime = endTime ?? DateTime.now();
    this.attemptNumber = attemptNumber;
    
    calculateResults();
    
    // Load the user's name
    _loadUserName();
    generateLeaderboard();
  }

  void calculateResults() {
    totalQuestions = test.questions.length;
    correctAnswers = 0;
    incorrectAnswers = 0;
    unansweredQuestions = 0;
    
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == -1) {
        unansweredQuestions++;
      } else if (selectedAnswers[i] == test.questions[i].correctAnswer) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }
    }
    
    percentageScore = (correctAnswers / totalQuestions) * 100;
    
    // Calculate marks using the marking scheme: 4 marks for correct, -1 for incorrect
    marksObtained = (correctAnswers * 4) - incorrectAnswers;
    totalMarks = totalQuestions * 4;
    
    // Calculate formatted time from totalTimeSpent
    int minutes = totalTimeSpent ~/ 60;
    int seconds = totalTimeSpent % 60;
    formattedTime = '${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}sec';
    
    // Set mock start and end times
    endTime = DateTime.now();
    startTime = endTime.subtract(Duration(seconds: totalTimeSpent));
  }
  
  void generateLeaderboard() {
    // In a real app, this would fetch data from a repository
    // For now, we'll use the mock data initialized above
    leaderboard[0]['score'] = marksObtained.toString();
  }
  
  // Load the user's name from the UserService
  Future<void> _loadUserName() async {
    try {
      // Get the user's first name (before the first space)
      final name = await _userService.getCurrentUserName();
      userName = name;
      
      // Update the leaderboard with the new name
      leaderboard[0]['name'] = '${userName}\'s';
      
      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user name: $e');
    }
  }
  
  String getFormattedDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }
  
  Color getOptionColor(int questionIndex, int optionIndex) {
    if (selectedAnswers[questionIndex] == optionIndex) {
      return optionIndex == test.questions[questionIndex].correctAnswer
          ? const Color(0xFFE6F4EA) // Light green for correct
          : const Color(0xFFFCE8E6); // Light red for incorrect
    } else if (optionIndex == test.questions[questionIndex].correctAnswer) {
      return const Color(0xFFE6F4EA); // Light green for correct answer
    }
    return Colors.white;
  }
  
  TextStyle getOptionTextStyle(int questionIndex, int optionIndex) {
    final bool isSelected = selectedAnswers[questionIndex] == optionIndex;
    final bool isCorrect = optionIndex == test.questions[questionIndex].correctAnswer;
    
    if (isSelected && !isCorrect) {
      return const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );
    } else if (isCorrect) {
      return const TextStyle(
        color: Color(0xFF76B947),
        fontWeight: FontWeight.bold,
      );
    }
    
    return const TextStyle(
      color: Colors.black,
    );
  }
}