import 'package:flutter/material.dart';
import '../../domain/models/ntet_mcq.dart';
import 'purchase_dialog.dart';
import 'bookmark_button.dart';
import '../../../shared/widgets/blue_white_container.dart';
import '../screens/mcq_instructions_screen.dart';

class MCQItem extends StatelessWidget {
  final NTETMCQ mcq;

  const MCQItem({Key? key, required this.mcq}) : super(key: key);
  
  // Show confirmation dialog for unlocked MCQs
  void _showConfirmationDialog(BuildContext context, NTETMCQ mcq) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: BlueWhiteContainer(
            title: "Physics Chapter 1 Mock Test Series",
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/domus_logo.png',
                  height: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please Read the Instructions Carefully",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "GENERAL INSTRUCTIONS:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInstructionItem("Make sure you have selected the correct subject before proceeding."),
                _buildInstructionItem("Read all the questions carefully before answering."),
                _buildInstructionItem("Ensure a stable and uninterrupted internet connection throughout the exam."),
                _buildInstructionItem("Do not refresh or close the browser/tab during the exam session."),
                _buildInstructionItem("Once an answer is submitted or time runs out, you may not be able to go back."),
                _buildInstructionItem("Avoid switching tabs or opening other applications — it may lead to disqualification."),
                _buildInstructionItem("The exam system may track your activity for security and fairness."),
                _buildInstructionItem("Only use the allowed materials or tools if mentioned in the instructions."),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to MCQ test screen (to be implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Starting MCQ Test...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001F54),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
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
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF204771),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!mcq.isLocked) {
                  // Navigate to MCQ instructions screen for unlocked MCQs
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MCQInstructionsScreen(
                        title: mcq.title,
                      ),
                    ),
                  );
                } else {
                  // Show purchase dialog for locked MCQs
                  PurchaseDialog.show(context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // MCQ Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/exam.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // MCQ details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mcq.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bookmark icon
                    BookmarkButton(),
                  ],
                ),
              ),
            ),
          ),
          // Lock overlay for locked MCQs
          if (mcq.isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show purchase dialog for locked MCQs
                    PurchaseDialog.show(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amber[700],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}