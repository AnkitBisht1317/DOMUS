import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domus/features/home/presentation/viewmodels/payment_viewmodel.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _donateToAIM = false;
  String _selectedPaymentMethod = '';
  String _couponCode = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PaymentViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        foregroundColor: Colors.white,
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: viewModel.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/cart_empty.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Main content in a scrollable area
                SingleChildScrollView(
                  // Add padding at bottom to ensure content isn't hidden behind the fixed button
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Batch Summary Card
                          _buildBatchSummaryCard(viewModel),
                          
                          // Apply Coupon Section
                          const SizedBox(height: 16),
                          _buildApplyCouponSection(),
                          
                          // Donation Option
                          const SizedBox(height: 16),
                          _buildDonationOption(),
                          
                          // User Details Section
                          const SizedBox(height: 16),
                          const Text(
                            'Your Details',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          _buildUserDetailsForm(),
                          
                          // Payment Method Section
                          const SizedBox(height: 16),
                          const Text(
                            'Payment Method',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          _buildPaymentMethodOptions(),
                          
                          // Payment Summary
                          const SizedBox(height: 16),
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Course Fee'),
            Text('₹${viewModel.totalAmount.toInt()}'),
          ],
        ),
        if (_donateToAIM) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Donation to AIM'),
              Text('₹10'),
            ],
          ),
        ],
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '₹${(_donateToAIM ? viewModel.totalAmount + 10 : viewModel.totalAmount).toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  ),
),
                          
                          // Secure Payment Text
                          const SizedBox(height: 16),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.lock, size: 16, color: Colors.grey),
    SizedBox(width: 8),
    Text(
      'Secure Payment by Razorpay',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
  ],
),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Fixed position payment button
                _buildFixedPayButton(viewModel),
              ],
            ),
    );
  }

  Widget _buildBatchSummaryCard(PaymentViewModel viewModel) {
    final item = viewModel.cartItems.first;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Batch Summary Header
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Batch Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1),
          
          // Batch Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('assets/books.png'),
                ),
                const SizedBox(width: 12),
                
                // Course Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text('Batch Duration: ${item.batchDuration}'),
                      const SizedBox(height: 4),
                      Text('Starts: ${item.startDate.isNotEmpty ? item.startDate : "2023-04-01"}'),
                      const SizedBox(height: 4),
                      Text('Ends: ${item.endDate.isNotEmpty ? item.endDate : "2024-02-28"}'),
                    ],
                  ),
                ),
                
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${item.price.toInt()}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₹${viewModel.totalAmount.toInt()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyCouponSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.blue),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Apply Code/Coupon'),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply coupon logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationOption() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Expanded(
              child: Text('Donate to AIM Homeopathy'),
            ),
            const Text('₹10'),
            Checkbox(
              value: _donateToAIM,
              onChanged: (value) {
                setState(() {
                  _donateToAIM = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Student Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Student Email',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOptions() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildPaymentMethodOption('UPI'),
          const Divider(height: 1),
          _buildPaymentMethodOption('Debit/Credit Card'),
          const Divider(height: 1),
          _buildPaymentMethodOption('Net Banking'),
          const Divider(height: 1),
          _buildPaymentMethodOption('Wallets'),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.diamond, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(method),
          ),
          Radio<String>(
            value: method,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value ?? '';
              });
            },
          ),
        ],
      ),
    );
  }

  // Updated method for the fixed payment button at the bottom
  Widget _buildFixedPayButton(PaymentViewModel viewModel) {
    return Positioned(
      bottom: 20, // Position it higher than before
      left: 16,
      right: 16,
      child: Container(
        width: double.infinity,
        height: 50, // Make it more compact
        decoration: BoxDecoration(
          color: Colors.blue, // Solid blue color like in the image
          borderRadius: BorderRadius.circular(15), // Fully rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // Process payment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Payment...')),
                );
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: Text(
                'Pay ₹${viewModel.totalAmount.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Remove or comment out the original _buildPayButton method since we're using the fixed one
  // Widget _buildPayButton(PaymentViewModel viewModel) { ... }
}