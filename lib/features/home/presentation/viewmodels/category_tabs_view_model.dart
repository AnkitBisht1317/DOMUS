import 'package:flutter/foundation.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/category_icon.dart';

class CategoryTabsViewModel extends ChangeNotifier {
  List<CategoryTab> _tabs = [];
  List<CategoryIcon> _icons = [];
  int _selectedTabIndex = 0;

  List<CategoryTab> get tabs => _tabs;
  List<CategoryIcon> get icons => _icons;
  int get selectedTabIndex => _selectedTabIndex;

  CategoryTabsViewModel() {
    _initializeTabs();
    _initializeIcons();
  }

  void _initializeTabs() {
    _tabs = [
      CategoryTab(title: "All", isSelected: true),
      CategoryTab(title: "Exam"),
      CategoryTab(title: "Study"),
      CategoryTab(title: "Revision"),
      CategoryTab(title: "Community"),
    ];
  }

  void _initializeIcons() {
    _icons = [
      CategoryIcon(
        title: 'NTET',
        imagePath: 'assets/books.png',
      ),
      CategoryIcon(
        title: 'Entrance',
        imagePath: 'assets/exam.png',
      ),
      CategoryIcon(
        title: 'Subject Wise MCQ',
        imagePath: 'assets/test.png',
        fontSize: 9,
      ),
      CategoryIcon(
        title: 'Professionals Corner',
        imagePath: 'assets/medicos_corner.png',
        fontSize: 9,
      ),
      CategoryIcon(
        title: 'CBDC',
        imagePath: 'assets/medicine.png',
      ),
      CategoryIcon(
        title: 'Study Notes',
        imagePath: 'assets/study_notes.png',
        fontSize: 11,
      ),
      CategoryIcon(
        title: 'HMM',
        imagePath: 'assets/hmm.png',
      ),
      CategoryIcon(
        title: 'Aphorism',
        imagePath: 'assets/aphorism.png',
        fontSize: 11,
      ),
      CategoryIcon(
        title: 'OP',
        imagePath: 'assets/op.png',
      ),
      CategoryIcon(
        title: 'Therapeutics',
        imagePath: 'assets/therapeutic.png',
        fontSize: 9,
      ),
    ];
  }

  void selectTab(int index) {
    if (index != _selectedTabIndex && index < _tabs.length) {
      _tabs = _tabs.asMap().map((i, tab) {
        return MapEntry(
          i,
          tab.copyWith(isSelected: i == index),
        );
      }).values.toList();
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void onIconTap(int index) {
    // Implement icon tap functionality
  }
} 