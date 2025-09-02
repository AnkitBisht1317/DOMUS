import 'package:domus/features/ntet/domain/models/mcq_test_model.dart';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class MCQTestResultViewModel extends ChangeNotifier {
  MCQTest test; // Removed final to allow updating questions with explanations
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
    
    // Add sample explanations to questions for the Description tab
    _addSampleExplanations();
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
      // Get the user's first name for the performance header
      final firstName = await _userService.getCurrentUserName();
      userName = firstName;
      
      // Get the user's full name for the leaderboard
      final fullName = await _userService.getCurrentUserFullName();
      
      // Update the leaderboard with the full name (no apostrophe 's')
      leaderboard[0]['name'] = fullName;
      
      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user name: $e');
    }
  }
  
  void _addSampleExplanations() {
    // This is a temporary method to add sample explanations to questions
    // In a real app, these would come from the backend
    final List<String> sampleExplanations = [
      "Aconitum Napellus is primarily indicated in inflammatory fevers with sudden onset, restlessness, and anxiety.",
      "Sensitivity to noise, especially music, is a characteristic symptom of Aconitum Napellus in ear complaints.",
      "Aconitum Napellus is often used in the first stage of inflammatory conditions with high fever.",
      "Aconitum Napellus is indicated when there is fear, anxiety, and restlessness accompanying physical symptoms.",
      "Aconitum Napellus is particularly useful in conditions triggered by exposure to cold, dry winds."
    ];
    
    // Create a new list of questions with explanations
    final updatedQuestions = <MCQQuestion>[];
    
    for (int i = 0; i < test.questions.length; i++) {
      final question = test.questions[i];
      final explanation = i < sampleExplanations.length ? sampleExplanations[i] : "No explanation available for this question.";
      
      // Create a new question with the same properties plus an explanation
      updatedQuestions.add(MCQQuestion(
        question: question.question,
        options: question.options,
        correctAnswer: question.correctAnswer,
        timeSpent: question.timeSpent,
        explanation: explanation,
      ));
    }
    
    // Replace the test questions with the updated ones
    test = MCQTest(
      title: test.title,
      questions: updatedQuestions,
      totalTime: test.totalTime,
    );
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