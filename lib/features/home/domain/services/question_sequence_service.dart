import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/question_of_day.dart';

class QuestionSequenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache for activity question counts
  Map<String, int> _activityQuestionCounts = {};
  
  // Get the question for today based on the sequence
  Future<Question?> getQuestionForToday() async {
    try {
      // Get current date and time in IST
      final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)); // IST is UTC+5:30
      final today = DateTime(now.year, now.month, now.day);
      
      // Format the date as YYYY-MM-DD for reference
      final dateString = DateFormat('yyyy-MM-dd').format(today);
      
      // 1. Get the sequence from QOTDQuestions/QuestionsSequence
      final sequenceDoc = await _firestore.collection('QOTDQuestions').doc('QuestionsSequence').get();
      
      if (!sequenceDoc.exists || sequenceDoc.data() == null) {
        print('Sequence document does not exist');
        return null;
      }
      
      final data = sequenceDoc.data()!;
      if (!data.containsKey('sequence') || !(data['sequence'] is List)) {
        print('Invalid sequence format');
        return null;
      }
      
      // Get the sequence of activities
      final List<String> activitySequence = List<String>.from(data['sequence']);
      
      if (activitySequence.isEmpty) {
        print('Empty sequence');
        return null;
      }
      
      // 2. Get the current progress from QOTDQuestions/QOTDProgress
      final progressDoc = await _firestore.collection('QOTDQuestions').doc('QOTDProgress').get();
      
      // Default values if no progress exists yet
      Map<String, int> lastQuestionIndexes = {};
      DateTime lastShownDay = DateTime(2000); // Default old date
      
      // If we have saved progress, use it
      if (progressDoc.exists && progressDoc.data() != null) {
        final progressData = progressDoc.data()!;
        
        // Get the lastQuestionIndexes map
        if (progressData.containsKey('lastQuestionIndexes')) {
          final indexesData = progressData['lastQuestionIndexes'];
          if (indexesData is Map) {
            // Convert map to the correct type
            indexesData.forEach((key, value) {
              if (value is int) {
                lastQuestionIndexes[key.toString()] = value;
              }
            });
          }
        }
        
        // Get the lastShownDay timestamp
        if (progressData.containsKey('lastShownDay')) {
          final timestamp = progressData['lastShownDay'];
          if (timestamp is Timestamp) {
            lastShownDay = timestamp.toDate();
          }
        }
      }
      
      print('Last question indexes: $lastQuestionIndexes');
      print('Last shown day: $lastShownDay');
      print('Sequence: $activitySequence');
      
      // Check if we need to refresh the question based on time (9 AM IST)
      final shouldRefresh = shouldRefreshQuestion(lastShownDay);
      if (!shouldRefresh) {
        // If we don't need to refresh, try to get the last shown question
        // This is for when the app is opened multiple times on the same day
        final lastActivity = _findLastShownActivity(lastQuestionIndexes, activitySequence);
        if (lastActivity != null) {
          final lastIndex = lastQuestionIndexes[lastActivity] ?? 0;
          if (lastIndex > 0) {
            final question = await _fetchQuestionFromActivity(lastActivity, lastIndex);
            if (question != null) {
              final questionWithDate = Map<String, dynamic>.from(question);
              questionWithDate['activityName'] = lastActivity;
              questionWithDate['date'] = Timestamp.fromDate(today);
              return Question.fromMap(questionWithDate);
            }
          }
        }
      }
      
      // Check if we need to load question counts
      if (_activityQuestionCounts.isEmpty) {
        await _loadActivityQuestionCounts(activitySequence);
      }
      
      // 3. Determine which activity to use next based on the sequence
      // Find the next activity in the sequence that has questions available
      String selectedActivity = "";
      int selectedQuestionIndex = 0;
      
      // Try each activity in the sequence
      for (int i = 0; i < activitySequence.length; i++) {
        final activity = activitySequence[i];
        final currentIndex = lastQuestionIndexes[activity] ?? 0;
        final nextIndex = currentIndex + 1;
        
        // Check if this activity has more questions available
        if (_activityQuestionCounts.containsKey(activity) && 
            nextIndex <= _activityQuestionCounts[activity]!) {
          selectedActivity = activity;
          selectedQuestionIndex = nextIndex;
          break;
        }
      }
      
      // If we couldn't find a valid next question in the sequence, start over with higher indexes
      if (selectedActivity.isEmpty) {
        // Increment all indexes and try again
        for (final activity in activitySequence) {
          lastQuestionIndexes[activity] = (lastQuestionIndexes[activity] ?? 0) + 1;
        }
        
        // Try again with the incremented indexes
        for (int i = 0; i < activitySequence.length; i++) {
          final activity = activitySequence[i];
          final currentIndex = lastQuestionIndexes[activity] ?? 0;
          
          // Check if this activity has questions at the new index
          if (_activityQuestionCounts.containsKey(activity) && 
              currentIndex <= _activityQuestionCounts[activity]!) {
            selectedActivity = activity;
            selectedQuestionIndex = currentIndex;
            break;
          }
        }
      }
      
      // If we still couldn't find a valid question, return null
      if (selectedActivity.isEmpty) {
        print('No valid questions found in any activity');
        return null;
      }
      
      print('Selected activity: $selectedActivity, question index: $selectedQuestionIndex');
      
      // 4. Fetch the question from the database collection
      final question = await _fetchQuestionFromActivity(selectedActivity, selectedQuestionIndex);
      
      if (question != null) {
        // Create a Question object with today's date
        final questionWithDate = Map<String, dynamic>.from(question);
        questionWithDate['activityName'] = selectedActivity;
        questionWithDate['date'] = Timestamp.fromDate(today);
        
        // 5. Update the lastQuestionIndexes with the current index
        lastQuestionIndexes[selectedActivity] = selectedQuestionIndex;
        
        // 6. Save the updated progress to QOTDQuestions/QOTDProgress
        await _firestore.collection('QOTDQuestions').doc('QOTDProgress').set({
          'lastQuestionIndexes': lastQuestionIndexes,
          'lastShownDay': Timestamp.now()
        });
        
        return Question.fromMap(questionWithDate);
      } else {
        print('No question found for $selectedActivity with index $selectedQuestionIndex');
        return null;
      }
    } catch (e) {
      print('Error getting question for today: $e');
      return null;
    }
  }
  
  // Find the last activity that was shown based on lastQuestionIndexes
  String? _findLastShownActivity(Map<String, int> lastQuestionIndexes, List<String> activitySequence) {
    String? lastActivity;
    int highestIndex = -1;
    
    for (final activity in activitySequence) {
      final index = lastQuestionIndexes[activity] ?? 0;
      if (index > 0 && (lastActivity == null || index > highestIndex)) {
        lastActivity = activity;
        highestIndex = index;
      }
    }
    
    return lastActivity;
  }
  
  // Load the question counts for all activities in the sequence
  Future<void> _loadActivityQuestionCounts(List<String> activitySequence) async {
    try {
      for (final activityName in activitySequence) {
        final docSnapshot = await _firestore.collection('database').doc(activityName).get();
        int count = 0;
        if (docSnapshot.exists && docSnapshot.data() != null) {
          final data = docSnapshot.data()!;
          if (data.containsKey('Questions') && data['Questions'] is List) {
            count = (data['Questions'] as List).length;
          } else if (data.containsKey('questions') && data['questions'] is List) {
            count = (data['questions'] as List).length;
          }
        }
        _activityQuestionCounts[activityName] = count;
        print('Activity $activityName has $count questions');
      }
    } catch (e) {
      print('Error loading activity question counts: $e');
    }
  }
  
  // Check if it's time to refresh the question (9:00 AM IST)
  bool shouldRefreshQuestion(DateTime lastFetchTime) {
    // Convert to IST (UTC+5:30)
    final lastFetchIST = lastFetchTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    final nowIST = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    
    // Check if it's a new day and past 9:00 AM IST
    final isNewDay = lastFetchIST.year != nowIST.year || 
                     lastFetchIST.month != nowIST.month || 
                     lastFetchIST.day != nowIST.day;
                     
    final isPast9AM = nowIST.hour >= 9;
    
    // Refresh if:
    // 1. It's a new day and it's past 9 AM
    // 2. It's the same day but we last fetched before 9 AM and now it's past 9 AM
    if ((isNewDay && isPast9AM) || 
        (!isNewDay && lastFetchIST.hour < 9 && isPast9AM)) {
      return true;
    }
    
    return false;
  }
}

Future<Map<String, dynamic>?> _fetchQuestionFromActivity(String activityName, int questionIndex) async {
  final activityDoc = await FirebaseFirestore.instance.collection('database').doc(activityName).get();
  final data = activityDoc.data();
  if (data == null) return null;
  List<dynamic>? questions = data['Questions'] ?? data['questions'];
  if (questions == null || questions.length < questionIndex) return null;
  return questions[questionIndex - 1] as Map<String, dynamic>?;
}