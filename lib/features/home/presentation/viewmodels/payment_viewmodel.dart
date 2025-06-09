import 'package:flutter/material.dart';
import 'package:domus/features/home/domain/models/payment_model.dart';

// ViewModel for the Payment Screen
class PaymentViewModel extends ChangeNotifier {
  List<PaymentModel> _cartItems = [];
  double _itemDiscount = 0.0;
  double _couponDiscount = 0.0;
  double _deliveryCharge = 0.0;

  List<PaymentModel> get cartItems => _cartItems;
  double get itemDiscount => _itemDiscount;
  double get couponDiscount => _couponDiscount;
  double get deliveryCharge => _deliveryCharge;

  // Calculate subtotal before discounts
  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.total);
  
  // Calculate total after all discounts
  double get totalAmount => subtotal - _itemDiscount - _couponDiscount + _deliveryCharge;

  /*void addItemToCart(PaymentModel item) {
    _cartItems.add(item);
    notifyListeners();
  }*/

  void clearCart() {
    _cartItems.clear();
    _itemDiscount = 0.0;
    _couponDiscount = 0.0;
    _deliveryCharge = 0.0;
    notifyListeners();
  }

  // This method would be called when 'Buy Now' is pressed from a carousel item
  void buyNow(PaymentModel item) {
    _cartItems.clear(); // Clear previous items for a direct purchase
    _cartItems.add(item);
    // Don't apply additional discount since the price is already discounted
    _itemDiscount = 0.0; // Remove the 50% discount
    notifyListeners();
  }
  
  // Make addItemToCart behave the same as buyNow for consistency
  void addItemToCart(PaymentModel item) {
    _cartItems.clear(); // Clear previous items for consistency
    _cartItems.add(item);
    _itemDiscount = 0.0; // No additional discount
    notifyListeners();
  }
  
  // Add this method to prevent data loss when navigating back
  void preserveCartItems() {
    // This method intentionally does nothing to preserve the cart items
    // when navigating back to the payment screen
  }

  void applyCoupon(String code) {
    // Implement coupon logic here
    // For now, just set a sample discount
    _couponDiscount = 0.0;
    notifyListeners();
  }

  void setDeliveryCharge(double charge) {
    _deliveryCharge = charge;
    notifyListeners();
  }
}