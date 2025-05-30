import 'package:flutter/foundation.dart';
import '../../domain/models/course_item.dart';

class CourseCarouselViewModel extends ChangeNotifier {
  List<CourseItem> _courses = [];
  int _currentIndex = 0;

  List<CourseItem> get courses => _courses;
  int get currentIndex => _currentIndex;

  CourseCarouselViewModel() {
    _initializeCourses();
  }

  void _initializeCourses() {
    _courses = [
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
    notifyListeners();
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void addToCart(int courseIndex) {
    // Implement add to cart functionality
  }

  void buyNow(int courseIndex) {
    // Implement buy now functionality
  }
} 