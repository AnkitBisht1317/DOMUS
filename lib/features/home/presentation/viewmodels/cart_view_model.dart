import 'package:flutter/foundation.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/course_item.dart';

class CartViewModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  bool get isEmpty => _cartItems.isEmpty;

  // Add a course to cart
  void addToCart(CourseItem course) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == course.title);
    
    if (existingIndex == -1) {
      // Add new item if not in cart
      _cartItems.add(
        CartItem(
          id: course.title,
          title: course.title,
          subtitle: course.subtitle,
          price: course.price,
          imagePath: course.iconPaths.first,
        ),
      );
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Check if a course is in the cart
  bool isInCart(String courseId) {
    return _cartItems.any((item) => item.id == courseId);
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }
}