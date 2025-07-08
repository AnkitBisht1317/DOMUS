import 'package:flutter/material.dart';

import '../viewmodel/free_mock_viewmodel.dart';
import '../widgets/free_mock_card.dart';

class FreeMockScreen extends StatelessWidget {
  const FreeMockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = FreeMockViewModel();
    final mocks = viewModel.getFreeMockList();

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
          'Free Mock',
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
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: mocks.length,
                itemBuilder: (context, index) {
                  return FreeMockCard(freemock: mocks[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
