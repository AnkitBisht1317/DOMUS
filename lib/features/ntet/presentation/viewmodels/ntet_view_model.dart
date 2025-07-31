import 'package:flutter/material.dart';
import '../../domain/models/ntet_lecture.dart';
import '../../domain/models/ntet_note.dart';
import '../../domain/models/ntet_mcq.dart';

class NTETViewModel extends ChangeNotifier {
  List<NTETLecture> _lectures = [];
  List<NTETNote> _notes = [];
  List<NTETMCQ> _mcqs = [];
  String _selectedTab = "Notes";
  
  List<NTETLecture> get lectures => _lectures;
  List<NTETNote> get notes => _notes;
  List<NTETMCQ> get mcqs => _mcqs;
  String get selectedTab => _selectedTab;
  
  NTETViewModel() {
    _initializeLectures();
    _initializeNotes();
    _initializeMCQs();
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

  void _initializeNotes() {
    _notes = [
      NTETNote(
        title: "Physics Chapter 1 Complete Notes.",
        chapter: "Chapter 1",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter1.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 2 Complete Notes.",
        chapter: "Chapter 2",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter2.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 3 Complete Notes.",
        chapter: "Chapter 3",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter3.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 4 Complete Notes.",
        chapter: "Chapter 4",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter4.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 5 Complete Notes.",
        chapter: "Chapter 5",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter5.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 6 Complete Notes.",
        chapter: "Chapter 6",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter6.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 7 Complete Notes.",
        chapter: "Chapter 7",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter7.pdf",
      ),
      NTETNote(
        title: "Physics Chapter 8 Complete Notes.",
        chapter: "Chapter 8",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter8.pdf",
      ),
    ];
  }
  
  void _initializeMCQs() {
    _mcqs = [
      NTETMCQ(
        title: "Physics Chapter 1 Mock Test Series.",
        chapter: "Chapter 1",
        isLocked: false,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 2 Mock Test Series.",
        chapter: "Chapter 2",
        isLocked: false,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 3 Mock Test Series.",
        chapter: "Chapter 3",
        isLocked: false,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 4 Mock Test Series.",
        chapter: "Chapter 4",
        isLocked: true,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 5 Mock Test Series.",
        chapter: "Chapter 5",
        isLocked: true,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 6 Mock Test Series.",
        chapter: "Chapter 6",
        isLocked: true,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 7 Mock Test Series.",
        chapter: "Chapter 7",
        isLocked: true,
        questionCount: 20,
      ),
      NTETMCQ(
        title: "Physics Chapter 8 Mock Test Series.",
        chapter: "Chapter 8",
        isLocked: true,
        questionCount: 20,
      ),
    ];
  }

  void changeTab(String tab) {
    if (_selectedTab != tab) {
      _selectedTab = tab;
      notifyListeners();
    }
  }
}