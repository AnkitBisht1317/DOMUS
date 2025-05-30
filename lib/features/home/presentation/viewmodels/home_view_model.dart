import 'package:flutter/foundation.dart';
import '../../domain/models/home_banner.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/course_item.dart';

class HomeViewModel extends ChangeNotifier {
  List<HomeBanner> _banners = [];
  List<CategoryTab> _categoryTabs = [];
  List<CourseItem> _courseItems = [];
  int _selectedTabIndex = 0;

  List<HomeBanner> get banners => _banners;
  List<CategoryTab> get categoryTabs => _categoryTabs;
  List<CourseItem> get courseItems => _courseItems;
  int get selectedTabIndex => _selectedTabIndex;

  HomeViewModel() {
    _initializeData();
  }

  void _initializeData() {
    _initializeBanners();
    _initializeCategoryTabs();
    _initializeCourseItems();
  }

  void _initializeBanners() {
    _banners = [
      const HomeBanner(
        imagePath: 'assets/home_page_banner.png',
        title: 'Welcome to DOMUS',
        description: 'Your gateway to homeopathic education',
      ),
    ];
  }

  void _initializeCategoryTabs() {
    _categoryTabs = [
      CategoryTab(title: "All", isSelected: true),
      CategoryTab(title: "Exam"),
      CategoryTab(title: "Study"),
      CategoryTab(title: "Revision"),
      CategoryTab(title: "Community"),
    ];
  }

  void _initializeCourseItems() {
    _courseItems = [
      CourseItem(
        title: 'Vishal Megamart',
        subtitle: 'Complete batch',
        price: '₹999',
        discount: '20%',
        startDate: '2025-12-01',
        endDate: '2025-12-31',
        isNew: true,
      ),
      CourseItem(
        title: 'AIIMS',
        subtitle: 'Special batch',
        price: '₹1299',
        discount: '15%',
        startDate: '2025-11-15',
        endDate: '2025-12-15',
        isNew: true,
      ),
      CourseItem(
        title: 'UPSC',
        subtitle: 'Premium batch',
        price: '₹1499',
        discount: '25%',
        startDate: '2025-12-10',
        endDate: '2026-01-10',
        isNew: true,
      ),
    ];
  }

  void selectTab(int index) {
    if (index != _selectedTabIndex && index < _categoryTabs.length) {
      _categoryTabs = _categoryTabs.asMap().map((i, tab) {
        return MapEntry(
          i,
          tab.copyWith(isSelected: i == index),
        );
      }).values.toList();
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void navigateToCart() {
    // Implement cart navigation
  }

  void navigateToNotifications() {
    // Implement notifications navigation
  }

  void navigateToSearch() {
    // Implement search navigation
  }

  void navigateToMenu() {
    // Implement menu navigation
  }
} 