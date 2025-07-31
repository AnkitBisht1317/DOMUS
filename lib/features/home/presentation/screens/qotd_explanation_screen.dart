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
      // Use the viewModel's selectedOption if none was passed
      final effectiveSelectedOption = selectedOption ?? viewModel.selectedOption;
      
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
                      // Replace the mapping with individual option cards
                      _buildOptionCard(1, question),
                      _buildOptionCard(2, question),
                      _buildOptionCard(3, question),
                      _buildOptionCard(4, question),
                      
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

  // Update the method to use option numbers instead of option objects
  Widget _buildOptionCard(int option, question) {
    // Convert the selected option string to int for comparison
    final int? selectedOptionNumber = selectedOption != null ? int.tryParse(selectedOption!) : null;
    final bool isSelected = selectedOptionNumber == option;
    final bool isCorrect = question.answerNr == option;
    
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

    // Get the option text based on the option number
    String optionText = '';
    switch (option) {
      case 1: optionText = question.option1; break;
      case 2: optionText = question.option2; break;
      case 3: optionText = question.option3; break;
      case 4: optionText = question.option4; break;
    }



    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$option. ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(optionText),
          ),
          if (isCorrect)
            const Icon(Icons.check_circle, color: Colors.green),
          if (isSelected && !isCorrect)
            const Icon(Icons.cancel, color: Colors.red),
        ],
      ),
    );
  }
}