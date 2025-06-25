import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/question_view_model.dart';

class QOTDExplanationScreen extends StatelessWidget {
  final String? selectedOption;
  
  const QOTDExplanationScreen({Key? key, this.selectedOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionViewModel>(builder: (context, viewModel, _) {
      final question = viewModel.questionOfDay;
      if (question == null) {
        return const Scaffold(
          body: Center(child: Text('No question available')),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFF001F54),
        body: Column(
          children: [
            // Top container with title and back button
            Container(
              width: double.infinity,
              color: const Color(0xFF001F54),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Question of the Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content container with rounded top corners
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Text(
                          'Your Daily Challenge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001F54),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Question text
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Options with correct/incorrect highlighting
                      ...question.options.map((option) => _buildOptionCard(option, question)),
                      
                      const SizedBox(height: 24),
                      
                      // Descriptions header
                      const Text(
                        'Descriptions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001F54),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Description content
                      Text(
                        question.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // New method to build option cards with correct/incorrect highlighting
  Widget _buildOptionCard(option, question) {
    final bool isSelected = selectedOption == option.prefix;
    final bool isCorrect = question.correctOption == option.prefix;
    
    // Determine the background color based on selection and correctness
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    
    if (isSelected && isCorrect) {
      // Selected and correct
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green;
    } else if (isSelected && !isCorrect) {
      // Selected but incorrect
      backgroundColor = Colors.red.shade100;
      borderColor = Colors.red.shade300;
    } else if (isCorrect) {
      // Not selected but is the correct answer
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${option.prefix}.',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                option.text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isCorrect)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
            if (isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.red, size: 20),
          ],
        ),
      ),
    );
  }
}