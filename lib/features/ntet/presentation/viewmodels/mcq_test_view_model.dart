import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/mcq_test_model.dart';
import '../../domain/usecases/get_mcq_test_usecase.dart';
import '../../domain/usecases/submit_mcq_test_usecase.dart';
import '../../domain/usecases/save_mcq_progress_usecase.dart';
import '../../di/user_injection.dart';
import '../state/mcq_test_state.dart';
import '../screens/mcq_test_result_screen.dart';

// Question status enum for the summary screen
enum QuestionStatus {
  notVisited,
  answered,
  notAnswered,
  markedForReview,
  answeredAndMarked
}

class MCQTestViewModel extends ChangeNotifier {
  final GetMCQTestUseCase _getMCQTestUseCase;
  final SubmitMCQTestUseCase _submitMCQTestUseCase;
  final SaveMCQProgressUseCase _saveMCQProgressUseCase;

  // State management
  MCQTestState _state = const MCQTestState();
  Timer? _timer;
  
  // Track visited questions and marked for review
  List<bool> _visitedQuestions = [];
  List<bool> _markedForReview = [];

  // Getters that delegate to state
  MCQTest? get test => _state.test;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  int get currentQuestionIndex => _state.currentQuestionIndex;
  int get selectedAnswerIndex => _state.selectedAnswerIndex;
  List<int> get selectedAnswers => _state.selectedAnswers;
  List<int> get timeSpent => _state.timeSpent;
  int get remainingTime => _state.remainingTime;
  double get fontSize => _state.fontSize;
  String get selectedLanguage => _state.selectedLanguage;
  MCQQuestion? get currentQuestion => _state.test?.questions.isNotEmpty == true ? _state.test!.questions[_state.currentQuestionIndex] : null;
  bool get hasTimer => _timer != null;

  MCQTestViewModel(
    this._getMCQTestUseCase,
    this._submitMCQTestUseCase,
    this._saveMCQProgressUseCase,
  );

  // Update state and notify listeners
  void _updateState(MCQTestState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadTest(String title) async {
    _updateState(_state.copyWith(isLoading: true, error: null));

    try {
      final test = await _getMCQTestUseCase.execute(title);
      final selectedAnswers = List.filled(test.questions.length, -1);
      final timeSpent = List.filled(test.questions.length, 0);
      
      // Initialize tracking arrays
      _visitedQuestions = List.filled(test.questions.length, false);
      _markedForReview = List.filled(test.questions.length, false);
      
      // Mark first question as visited
      _visitedQuestions[0] = true;
      
      _updateState(_state.copyWith(
        isLoading: false,
        test: test,
        selectedAnswers: selectedAnswers,
        timeSpent: timeSpent,
        remainingTime: test.totalTime,
      ));
      
      _startTimer();
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void selectAnswer(int index) {
    final updatedSelectedAnswers = List<int>.from(_state.selectedAnswers);
    updatedSelectedAnswers[_state.currentQuestionIndex] = index;
    
    _updateState(_state.copyWith(
      selectedAnswerIndex: index,
      selectedAnswers: updatedSelectedAnswers,
    ));
    
    // Save progress
    _saveMCQProgressUseCase.execute(_state.test!.title, _state.currentQuestionIndex, index);
  }

  void nextQuestion() {
    if (_state.currentQuestionIndex < _state.test!.questions.length - 1) {
      // Mark current question as visited
      _visitedQuestions[_state.currentQuestionIndex] = true;
      
      final nextIndex = _state.currentQuestionIndex + 1;
      // Mark next question as visited
      _visitedQuestions[nextIndex] = true;
      
      _updateState(_state.copyWith(
        currentQuestionIndex: nextIndex,
        selectedAnswerIndex: _state.selectedAnswers[nextIndex],
      ));
    }
  }

  void previousQuestion() {
    if (_state.currentQuestionIndex > 0) {
      // Mark current question as visited
      _visitedQuestions[_state.currentQuestionIndex] = true;
      
      final prevIndex = _state.currentQuestionIndex - 1;
      // Mark previous question as visited
      _visitedQuestions[prevIndex] = true;
      
      _updateState(_state.copyWith(
        currentQuestionIndex: prevIndex,
        selectedAnswerIndex: _state.selectedAnswers[prevIndex],
      ));
    }
  }

  Future<void> submitTest(BuildContext context) async {
    if (hasTimer) {
      _timer!.cancel();
    }
    await _submitMCQTestUseCase.execute(_state.test!.title, _state.selectedAnswers, _state.timeSpent);
    
    // Calculate total time spent
    int totalTimeSpent = _state.timeSpent.fold(0, (sum, time) => sum + time);
    
    // Navigate to result screen without wrapping in MultiProvider
    // Use pushReplacement instead of pushAndRemoveUntil to maintain the provider tree
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MCQTestResultScreen(
          test: _state.test!,
          selectedAnswers: _state.selectedAnswers,
          totalTimeSpent: totalTimeSpent,
        ),
      ),
    );
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_state.remainingTime == 0) {
          timer.cancel();
          notifyListeners();
        } else {
          final updatedTimeSpent = List<int>.from(_state.timeSpent);
          updatedTimeSpent[_state.currentQuestionIndex]++;
          
          _updateState(_state.copyWith(
            remainingTime: _state.remainingTime - 1,
            timeSpent: updatedTimeSpent,
          ));
        }
      },
    );
  }

  String formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;
    
    return '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  void increaseFontSize() {
    if (_state.fontSize < 24.0) {
      _updateState(_state.copyWith(fontSize: _state.fontSize + 2.0));
    }
  }

  void decreaseFontSize() {
    if (_state.fontSize > 12.0) {
      _updateState(_state.copyWith(fontSize: _state.fontSize - 2.0));
    }
  }
  
  void setLanguage(String language) {
    _updateState(_state.copyWith(selectedLanguage: language));
  }
  
  // Methods for the summary screen
  QuestionStatus getQuestionStatus(int index) {
    if (!_visitedQuestions[index]) {
      return QuestionStatus.notVisited;
    } else if (_markedForReview[index] && _state.selectedAnswers[index] != -1) {
      return QuestionStatus.answeredAndMarked;
    } else if (_markedForReview[index]) {
      return QuestionStatus.markedForReview;
    } else if (_state.selectedAnswers[index] != -1) {
      return QuestionStatus.answered;
    } else {
      return QuestionStatus.notAnswered;
    }
  }
  
  int getNotVisitedCount() {
    return _visitedQuestions.where((visited) => !visited).length;
  }
  
  int getAnsweredCount() {
    int count = 0;
    for (int i = 0; i < _state.selectedAnswers.length; i++) {
      if (_state.selectedAnswers[i] != -1 && !_markedForReview[i]) {
        count++;
      }
    }
    return count;
  }
  
  int getNotAnsweredCount() {
    int count = 0;
    for (int i = 0; i < _visitedQuestions.length; i++) {
      if (_visitedQuestions[i] && _state.selectedAnswers[i] == -1 && !_markedForReview[i]) {
        count++;
      }
    }
    return count;
  }
  
  int getMarkedForReviewCount() {
    int count = 0;
    for (int i = 0; i < _markedForReview.length; i++) {
      if (_markedForReview[i] && _state.selectedAnswers[i] == -1) {
        count++;
      }
    }
    return count;
  }
  
  int getAnsweredAndMarkedCount() {
    int count = 0;
    for (int i = 0; i < _markedForReview.length; i++) {
      if (_markedForReview[i] && _state.selectedAnswers[i] != -1) {
        count++;
      }
    }
    return count;
  }
  
  void navigateToQuestion(int index) {
    if (index >= 0 && index < _state.test!.questions.length) {
      _visitedQuestions[index] = true;
      _updateState(_state.copyWith(
        currentQuestionIndex: index,
        selectedAnswerIndex: _state.selectedAnswers[index],
      ));
    }
  }
  
  void toggleMarkForReview() {
    final index = _state.currentQuestionIndex;
    _markedForReview[index] = !_markedForReview[index];
    notifyListeners();
  }

  @override
  void dispose() {
    if (hasTimer) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
