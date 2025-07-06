import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/qotd_explanation_screen.dart';
import '../viewmodels/question_view_model.dart';
import '../../domain/models/question_of_day.dart';

class QuestionOfDaySection extends StatefulWidget {
  const QuestionOfDaySection({Key? key}) : super(key: key);

  @override
  State<QuestionOfDaySection> createState() => _QuestionOfDaySectionState();
}

class _QuestionOfDaySectionState extends State<QuestionOfDaySection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionViewModel>(  
      builder: (context, viewModel, _) {
        final question = viewModel.questionOfDay;
        if (question == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF001F54),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      'Question of the Day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Date display with correct implementation
                    Text(
                      "${question.date.day}/${question.date.month}/${question.date.year}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Card
              Container(
                margin: const EdgeInsets.fromLTRB(1, 0, 1, 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Options - using the new model
                      _buildOptionCard(1, question.option1, question, viewModel),
                      _buildOptionCard(2, question.option2, question, viewModel),
                      _buildOptionCard(3, question.option3, question, viewModel),
                      _buildOptionCard(4, question.option4, question, viewModel),
                      
                      const SizedBox(height: 16),
                      // Bottom buttons
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Explicit check at the moment of click
                              if (viewModel.selectedOptionNumber != null || viewModel.hasAnswered) {
                                // Only navigate if an option is selected or previously answered
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider.value(
                                      value: viewModel,
                                      child: QOTDExplanationScreen(selectedOption: viewModel.selectedOption),
                                    ),
                                  ),
                                );
                              } else {
                                // Optional: Show a message that user needs to select an option
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select an option first'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                            ),
                            child: Text(
                              'Explain',
                              style: TextStyle(
                                color: viewModel.selectedOptionNumber != null || viewModel.hasAnswered
                                    ? const Color(0xFF001F54)
                                    : Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Update the More button to pass context to showMore
                          TextButton(
                            onPressed: () => viewModel.showMore(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text(
                              'More',
                              style: TextStyle(
                                color: Color(0xFF001F54),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Updated method to handle option selection using the viewModel
  Widget _buildOptionCard(int optionNumber, String optionText, Question question, QuestionViewModel viewModel) {
    final bool isSelected = viewModel.selectedOptionNumber == optionNumber;
    final bool isCorrect = question.answerNr == optionNumber;
    final bool showResult = viewModel.hasAnswered;
    
    // Determine the background color based on selection and correctness
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    
    if (showResult) {
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
    } else if (isSelected) {
      // Selected but result not shown yet
      backgroundColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade300;
    }

    // Calculate percentage if answer stats are available
    String percentageText = '';
    if (showResult && question.answerStats != null) {
      final stats = question.answerStats!;
      
      // Use the correct field name for total attempted
      final totalAttempted = stats['Total Answered'] ?? 0;
      
      if (totalAttempted > 0) {
        // Use the correct field name for option selected
        final optionSelected = stats['option${optionNumber} selected'] ?? 0;
        final percentage = (optionSelected / totalAttempted * 100).round();
        percentageText = '$percentage%';
      }
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: viewModel.hasAnswered ? null : () async {
            // Save the user's answer using the viewModel
            await viewModel.saveUserAnswer(optionNumber.toString());
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$optionNumber.',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    optionText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Show both icon and percentage
                if (showResult)
                  Row(
                    children: [
                      if (percentageText.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            percentageText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      /*if (isCorrect)
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      if (isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.red, size: 20),*/
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}