import 'package:flutter/material.dart';
import '../../domain/models/ntet_lecture.dart';

class NTETViewModel extends ChangeNotifier {
  List<NTETLecture> _lectures = [];
  String _selectedTab = "Lecture";
  
  List<NTETLecture> get lectures => _lectures;
  String get selectedTab => _selectedTab;
  
  NTETViewModel() {
    _initializeLectures();
  }
  
  void _initializeLectures() {
    _lectures = [
      NTETLecture(
        title: "Physics Chapter 1",
        chapter: "Chapter 1",
        lectureNumber: "Lecture 1",
        duration: "1:15:59",
        isLocked: false,
        progress: 0.7, // Added progress value
      ),
      NTETLecture(
        title: "Physics Chapter 2",
        chapter: "Chapter 2",
        lectureNumber: "Lecture 2",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 3",
        chapter: "Chapter 3",
        lectureNumber: "Lecture 3",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 4",
        chapter: "Chapter 4",
        lectureNumber: "Lecture 4",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 5",
        chapter: "Chapter 5",
        lectureNumber: "Lecture 5",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 6",
        chapter: "Chapter 6",
        lectureNumber: "Lecture 6",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 7",
        chapter: "Chapter 7",
        lectureNumber: "Lecture 7",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      NTETLecture(
        title: "Physics Chapter 8",
        chapter: "Chapter 8",
        lectureNumber: "Lecture 8",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
    ];
    notifyListeners();
  }
  
  void changeTab(String tab) {
    if (_selectedTab != tab) {
      _selectedTab = tab;
      notifyListeners();
    }
  }
}