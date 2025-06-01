import 'package:flutter/foundation.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/category_icon.dart';

class CategoryTabsViewModel extends ChangeNotifier {
  List<CategoryTab> _tabs = [];
  List<CategoryIcon> _allIcons = [];
  List<CategoryIcon> _filteredIcons = [];
  CategoryType _selectedCategory = CategoryType.all;

  List<CategoryTab> get tabs => _tabs;
  List<CategoryIcon> get icons => _filteredIcons;
  CategoryType get selectedCategory => _selectedCategory;

  CategoryTabsViewModel() {
    _initializeTabs();
    _initializeIcons();
  }

  void _initializeTabs() {
    _tabs = [
      CategoryTab(type: CategoryType.all, title: "All", isSelected: true),
      CategoryTab(type: CategoryType.exam, title: "Exam"),
      CategoryTab(type: CategoryType.study, title: "Study"),
      CategoryTab(type: CategoryType.revision, title: "Revision"),
      CategoryTab(type: CategoryType.community, title: "Community"),
    ];
  }

  void _initializeIcons() {
    _allIcons = [
      CategoryIcon(
        title: 'NTET',
        imagePath: 'assets/books.png',
        categories: [CategoryType.exam],
      ),
      CategoryIcon(
        title: 'Entrance',
        imagePath: 'assets/exam.png',
        categories: [CategoryType.exam],
      ),
      CategoryIcon(
        title: 'Subject Wise MCQ',
        imagePath: 'assets/test.png',
        categories: [CategoryType.exam, CategoryType.study],
      ),
      CategoryIcon(
        title: 'Professionals Corner',
        imagePath: 'assets/medicos_corner.png',
        categories: [CategoryType.community],
      ),
      CategoryIcon(
        title: 'CBDC',
        imagePath: 'assets/medicine.png',
        categories: [CategoryType.exam],
      ),
      CategoryIcon(
        title: 'Study Notes',
        imagePath: 'assets/study_notes.png',
        categories: [CategoryType.study],
      ),
      CategoryIcon(
        title: 'HMM',
        imagePath: 'assets/hmm.png',
        categories: [CategoryType.study],
      ),
      CategoryIcon(
        title: 'Aphorism',
        imagePath: 'assets/aphorism.png',
        categories: [CategoryType.study],
      ),
      CategoryIcon(
        title: 'OP',
        imagePath: 'assets/op.png',
        categories: [CategoryType.study, CategoryType.revision],
      ),
      CategoryIcon(
        title: 'Therapeutics',
        imagePath: 'assets/therapeutic.png',
        categories: [CategoryType.study, CategoryType.revision],
      ),
    ];
    _filterIcons();
  }

  void _filterIcons() {
    if (_selectedCategory == CategoryType.all) {
      _filteredIcons = List.from(_allIcons);
    } else {
      _filteredIcons = _allIcons.where((icon) => 
        icon.categories.contains(_selectedCategory)
      ).toList();
    }
    notifyListeners();
  }

  void selectTab(int index) {
    if (index < _tabs.length) {
      final newCategory = _tabs[index].type;
      if (newCategory != _selectedCategory) {
        _selectedCategory = newCategory;
        _tabs = _tabs.asMap().map((i, tab) {
          return MapEntry(
            i,
            tab.copyWith(isSelected: i == index),
          );
        }).values.toList();
        _filterIcons();
      }
    }
  }

  void onIconTap(int index) {
    // Implement icon tap functionality
  }
} 