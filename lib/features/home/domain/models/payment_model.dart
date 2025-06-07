// Model for the Payment Screen
class PaymentModel {
  final String itemName;
  final double price;
  final int quantity;
  final String batchDuration;
  final String startDate;
  final String endDate;

  PaymentModel({
    required this.itemName,
    required this.price,
    required this.quantity,
    this.batchDuration = "1Year",
    this.startDate = "",
    this.endDate = "",
  });

  double get total => price * quantity;
}