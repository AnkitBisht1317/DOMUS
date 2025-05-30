import 'package:flutter/foundation.dart';
import '../../domain/models/lecture.dart';

class LecturesViewModel extends ChangeNotifier {
  List<Lecture> _lectures = [];
  
  List<Lecture> get lectures => _lectures;

  LecturesViewModel() {
    _initializeLectures();
  }

  void _initializeLectures() {
    _lectures = [
      Lecture(
        title: 'Physics Chapter 1 || Lecture 2',
        duration: '1:15:59',
        imagePath: 'assets/banner_varient_fifth.png',
        progress: 0.3,
      ),
      Lecture(
        title: 'Chemistry Chapter 1 || Lecture 2',
        duration: '1:15:59',
        imagePath: 'assets/banner_varient_fourth.png',
        progress: 0.5,
      ),
      Lecture(
        title: 'Maths Chapter 1 || Lecture 3',
        duration: '1:15:59',
        imagePath: 'assets/banner_varient_sixth.png',
        progress: 0.0,
      ),
      Lecture(
        title: 'Physics Chapter 1 || Lecture 2',
        duration: '1:15:59',
        imagePath: 'assets/banner_varient_third.png',
        progress: 0.2,
      ),
    ];
    notifyListeners();
  }

  void updateLectureProgress(int index, double progress) {
    if (index >= 0 && index < _lectures.length) {
      _lectures[index] = Lecture(
        title: _lectures[index].title,
        duration: _lectures[index].duration,
        imagePath: _lectures[index].imagePath,
        progress: progress,
      );
      notifyListeners();
    }
  }

  void onMoreTap(int index) {

  }
} 