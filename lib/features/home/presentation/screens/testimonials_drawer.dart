import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/testimonials_drawer_view_model.dart';
import '../widgets/testimonials_card.dart';

class TestimonialsDrawer extends StatelessWidget {
  const TestimonialsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TestimonialsDrawerViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF022150),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.06),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Testimonials',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      itemCount: viewModel.doctors.length,
                      itemBuilder: (context, index) {
                        return TestimonialsCard(
                            doctor: viewModel.doctors[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
