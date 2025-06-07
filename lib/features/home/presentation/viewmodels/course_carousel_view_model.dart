import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../domain/models/course_item.dart';
import 'cart_view_model.dart';

class CourseCarouselViewModel extends ChangeNotifier {
  List<CourseItem> _courses = [];
  int _currentIndex = 0;
  // Store a reference to the cart view model
  CartViewModel? _cartViewModel;

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

  // Set the cart view model reference
  void setCartViewModel(CartViewModel cartViewModel) {
    _cartViewModel = cartViewModel;
  }

  void addToCart(int courseIndex) {
    if (courseIndex >= 0 && courseIndex < _courses.length) {
      final course = _courses[courseIndex];
      // Get the cart view model from the BuildContext
      final cartViewModel = _cartViewModel;
      if (cartViewModel != null) {
        cartViewModel.addToCart(course);
        notifyListeners();
      }
    }
  }

  bool isInCart(int courseIndex) {
    if (courseIndex >= 0 && courseIndex < _courses.length) {
      final course = _courses[courseIndex];
      final cartViewModel = _cartViewModel;
      if (cartViewModel != null) {
        return cartViewModel.isInCart(course.title);
      }
    }
    return false;
  }

  void buyNow(int courseIndex) {
    // Implement buy now functionality
  }
}