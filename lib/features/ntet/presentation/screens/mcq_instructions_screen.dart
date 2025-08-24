import 'package:flutter/material.dart';
import 'mcq_test_screen.dart';

class MCQInstructionsScreen extends StatelessWidget {
  final String title;

  const MCQInstructionsScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F54),
      body: SafeArea(
        child: Column(
          children: [
            // Top container with title and back button
            Container(
              width: double.infinity,
              color: const Color(0xFF001F54),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content with white container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20),
                    // Logo
                    Image.asset(
                      'assets/logo_darker.png',
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    
                    // Instructions header
                    const Text(
                      "Please Read the Instructions Carefully",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // General instructions header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "GENERAL INSTRUCTIONS:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001F54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Instructions list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionItem("Make sure you have selected the correct subject before proceeding."),
                          _buildInstructionItem("Read all the questions carefully before answering."),
                          _buildInstructionItem("Ensure a stable and uninterrupted internet connection throughout the exam."),
                          _buildInstructionItem("Do not refresh or close the browser/tab during the exam session."),
                          _buildInstructionItem("Once an answer is submitted or time runs out, you may not be able to go back."),
                          _buildInstructionItem("Avoid switching tabs or opening other applications — it may lead to disqualification."),
                          _buildInstructionItem("The exam system may track your activity for security and fairness."),
                          _buildInstructionItem("Only use the allowed materials or tools if mentioned in the instructions."),
                          _buildInstructionItem("Keep Your student id and verification id ready if needed"),
                          _buildInstructionItem("Click on START EXAM only when you are fully prepared"),
                        ],
                      ),
                    ),
                    
                    // OK Button
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to MCQ test screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MCQTestScreen(title: title),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF001F54),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001F54),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF001F54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}