import 'package:domus/features/home/domain/models/payment_model.dart';
import 'package:domus/features/home/presentation/screens/payment_screen.dart';
import 'package:domus/features/home/presentation/viewmodels/payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/cart_item.dart';
import '../viewmodels/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        foregroundColor: Colors.white,
        title: const Text('Your Domus Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.isEmpty) {
            return _buildEmptyCart();
          }

          return _buildCartWithItems(context, viewModel);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          color: const Color(0xFFF0F0F0),
          child: const Text(
            'Saved for later (0 item)',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/cart_empty.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Domus Cart is Empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Image.asset(
                  'assets/logo_darker.png',
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartWithItems(BuildContext context, CartViewModel viewModel) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          color: const Color(0xFFF0F0F0),
          child: Text(
            'Saved for later (${viewModel.cartItems.length} item${viewModel.cartItems.length > 1 ? 's' : ''})',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.cartItems.length,
            itemBuilder: (context, index) {
              final item = viewModel.cartItems[index];
              return CartItemCard(
                  item: item,
                  viewModel:
                      viewModel); // Pass context to CartItemCard if needed for navigation inside it
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Image.asset(
            'assets/logo_darker.png',
            height: 50,
          ),
        ),
      ],
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartViewModel viewModel;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Course details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/logo_darker.png',
                        height: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < item.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => viewModel.removeFromCart(item.id),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        // Inside the onPressed method of Buy button
                        onPressed: () {
                          final paymentViewModel =
                              Provider.of<PaymentViewModel>(context,
                                  listen: false);
                          // Convert CartItem to PaymentModel
                          final paymentItem = PaymentModel(
                            itemName: item.title,
                            price: double.parse(item.price
                                .replaceAll('₹', '')
                                .replaceAll(',', '')), // Handle ₹ symbol
                            quantity:
                                1, // Assuming quantity is 1 for a single item buy from cart
                            batchDuration: "1Year",
                            startDate: item.startDate ??
                                "", // Use cart item start date if available
                            endDate: item.endDate ??
                                "", // Use cart item end date if available
                          );
                          paymentViewModel.addItemToCart(
                              paymentItem); // Use addItemToCart for consistency

                          // Direct navigation to PaymentScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Buy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
