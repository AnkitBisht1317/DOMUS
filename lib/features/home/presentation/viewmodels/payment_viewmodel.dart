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

  void addItemToCart(PaymentModel item) {
    _cartItems.add(item);
    notifyListeners();
  }

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
    // Set default discount for the item (can be adjusted based on business logic)
    _itemDiscount = item.total * 0.5; // 50% discount as shown in the image
    notifyListeners();
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