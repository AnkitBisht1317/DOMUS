class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imagePath;
  final double rating;
  final String? startDate; // Add start date
  final String? endDate; // Add end date

  CartItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    this.rating = 4.5,
    this.startDate, // Initialize start date
    this.endDate, // Initialize end date
  });
}