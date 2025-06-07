class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imagePath;
  final double rating;

  const CartItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    this.rating = 4.0,
  });
}