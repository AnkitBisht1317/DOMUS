import 'package:domus/features/medicosCorner/domain/model/Subject_wise_note.dart';
import 'package:domus/features/medicosCorner/domain/model/subject_wise_mcq.dart';
import 'package:domus/features/medicosCorner/domain/model/subject_wise_model.dart';
import 'package:flutter/material.dart';

class SubjectWiseViewModel extends ChangeNotifier {
  List<SubjectWiseModel> _lectures = [];
  List<SubjectWiseNotes> _notes = [];
  List<SubjectWiseMCQ> _mcqs = [];
  String _selectedTab = "Notes";

  List<SubjectWiseModel> get lectures => _lectures;
  List<SubjectWiseNotes> get notes => _notes;
  List<SubjectWiseMCQ> get mcqs => _mcqs;
  String get selectedTab => _selectedTab;

  NTETViewModel() {
    _initializeLectures();
    _initializeNotes();
    _initializeMCQs();
  }

  void _initializeLectures() {
    _lectures = [
      SubjectWiseModel(
        title: "Physics Chapter 1",
        chapter: "Chapter 1",
        lectureNumber: "Lecture 1",
        duration: "1:15:59",
        isLocked: false,
        progress: 0.7, // Added progress value
      ),
      SubjectWiseModel(
        title: "Physics Chapter 2",
        chapter: "Chapter 2",
        lectureNumber: "Lecture 2",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
        title: "Physics Chapter 3",
        chapter: "Chapter 3",
        lectureNumber: "Lecture 3",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
        title: "Physics Chapter 4",
        chapter: "Chapter 4",
        lectureNumber: "Lecture 4",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
        title: "Physics Chapter 5",
        chapter: "Chapter 5",
        lectureNumber: "Lecture 5",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
        title: "Physics Chapter 6",
        chapter: "Chapter 6",
        lectureNumber: "Lecture 6",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
        title: "Physics Chapter 7",
        chapter: "Chapter 7",
        lectureNumber: "Lecture 7",
        duration: "1:15:59",
        isLocked: true,
        progress: 0.0,
      ),
      SubjectWiseModel(
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
      SubjectWiseNotes(
        title: "Physics Chapter 1 Complete Notes.",
        chapter: "Chapter 1",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter1.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 2 Complete Notes.",
        chapter: "Chapter 2",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter2.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 3 Complete Notes.",
        chapter: "Chapter 3",
        isLocked: false,
        pdfPath: "assets/pdfs/physics_chapter3.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 4 Complete Notes.",
        chapter: "Chapter 4",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter4.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 5 Complete Notes.",
        chapter: "Chapter 5",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter5.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 6 Complete Notes.",
        chapter: "Chapter 6",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter6.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 7 Complete Notes.",
        chapter: "Chapter 7",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter7.pdf",
      ),
      SubjectWiseNotes(
        title: "Physics Chapter 8 Complete Notes.",
        chapter: "Chapter 8",
        isLocked: true,
        pdfPath: "assets/pdfs/physics_chapter8.pdf",
      ),
    ];
  }

  void _initializeMCQs() {
    _mcqs = [
      SubjectWiseMCQ(
        title: "Physics Chapter 1 Mock Test Series.",
        chapter: "Chapter 1",
        isLocked: false,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 2 Mock Test Series.",
        chapter: "Chapter 2",
        isLocked: false,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 3 Mock Test Series.",
        chapter: "Chapter 3",
        isLocked: false,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 4 Mock Test Series.",
        chapter: "Chapter 4",
        isLocked: true,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 5 Mock Test Series.",
        chapter: "Chapter 5",
        isLocked: true,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 6 Mock Test Series.",
        chapter: "Chapter 6",
        isLocked: true,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
        title: "Physics Chapter 7 Mock Test Series.",
        chapter: "Chapter 7",
        isLocked: true,
        questionCount: 20,
      ),
      SubjectWiseMCQ(
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
