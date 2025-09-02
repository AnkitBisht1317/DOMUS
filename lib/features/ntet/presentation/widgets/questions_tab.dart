import 'package:flutter/material.dart';
import '../viewmodels/mcq_test_result_view_model.dart';

class QuestionsTabWidget extends StatelessWidget {
  final MCQTestResultViewModel viewModel;

  const QuestionsTabWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Question cards
          ...List.generate(
            viewModel.test.questions.length,
            (index) => _buildQuestionCard(context, index),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, int questionIndex) {
    final question = viewModel.test.questions[questionIndex];
    final selectedAnswer = viewModel.selectedAnswers[questionIndex];
    final correctAnswer = question.correctAnswer;
    final isCorrect = selectedAnswer == correctAnswer;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(
              'Q.${questionIndex + 1}) ${question.question}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Options
            ...List.generate(
              question.options.length,
              (optionIndex) => _buildOptionItem(
                optionIndex,
                question.options[optionIndex],
                optionIndex == correctAnswer,
                optionIndex == selectedAnswer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    int optionIndex,
    String optionText,
    bool isCorrect,
    bool isSelected,
  ) {
    // Option letter based on index (a, b, c, d)
    final optionLetter = String.fromCharCode(97 + optionIndex);
    
    // Text color based on whether it's correct or selected
    Color textColor = Colors.black87;
    if (isCorrect) {
      textColor = const Color(0xFF76B947); // Green for correct answer
    } else if (isSelected && !isCorrect) {
      textColor = Colors.red; // Red for incorrect selected answer
    }
    
    // Font weight based on whether it's correct or selected
    FontWeight fontWeight = FontWeight.normal;
    if (isCorrect || isSelected) {
      fontWeight = FontWeight.bold;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$optionLetter) ',
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              optionText,
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}