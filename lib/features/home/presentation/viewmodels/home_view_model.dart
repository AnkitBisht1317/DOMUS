import 'package:flutter/foundation.dart';
import '../../domain/models/category_icon.dart';
import '../../domain/models/home_banner.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/course_item.dart';
import '../../domain/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _homeRepository;
  List<HomeBanner> _banners = [];
  List<CategoryTab> _categoryTabs = [];
  List<CourseItem> _courseItems = [];
  int _selectedTabIndex = 0;

  List<HomeBanner> get banners => _banners;
  List<CategoryTab> get categoryTabs => _categoryTabs;
  List<CourseItem> get courseItems => _courseItems;
  int get selectedTabIndex => _selectedTabIndex;

  HomeViewModel(this._homeRepository) {
    _initializeData();
  }

  void _initializeData() {
    _initializeBanners();
    _initializeCategoryTabs();
    _initializeCourseItems();
  }

  void _initializeBanners() {
    _banners = [
      const HomeBanner(imagePath: 'assets/home_page_banner.png'),
      const HomeBanner(imagePath: 'assets/banner_varient_second.png'),
      const HomeBanner(imagePath: 'assets/banner_varient_third.png'),
      const HomeBanner(imagePath: 'assets/banner_varient_fourth.png'),
      const HomeBanner(imagePath: 'assets/banner_varient_fifth.png'),
      const HomeBanner(imagePath: 'assets/banner_varient_sixth.png'),
    ];
  }

  void _initializeCategoryTabs() {
    _categoryTabs = [
      CategoryTab(type: CategoryType.all, title: "All", isSelected: true),
      CategoryTab(type: CategoryType.exam, title: "Exam"),
      CategoryTab(type: CategoryType.study, title: "Study"),
      CategoryTab(type: CategoryType.revision, title: "Revision"),
      CategoryTab(type: CategoryType.community, title: "Community"),
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
    // This method will be called when the cart icon is pressed
    // You can add any additional logic here if needed
  }

  void navigateToNotifications() {
    // This method will be called from the UI when needed
  }
  void navigateToSearch() {
    // Implement search navigation
  }

  void navigateToMenu() {
    // Implement menu navigation
  }
}