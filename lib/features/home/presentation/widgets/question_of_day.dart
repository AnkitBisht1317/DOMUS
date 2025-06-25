import 'package:domus/features/home/domain/models/questions_options_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/qotd_explanation_screen.dart';
import '../viewmodels/question_view_model.dart';
import '../../domain/models/question_of_day.dart';
import 'package:animations/animations.dart';

class QuestionOfDaySection extends StatefulWidget {
  const QuestionOfDaySection({Key? key}) : super(key: key);

  @override
  State<QuestionOfDaySection> createState() => _QuestionOfDaySectionState();
}

class _QuestionOfDaySectionState extends State<QuestionOfDaySection> {
  String? selectedOption;
  bool hasAnswered = false;

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
                      
                      // Options - fixed to show only once
                      ...question.options.map((option) => _buildOptionCard(option, question)),
                      
                      const SizedBox(height: 16),
                      // Bottom buttons
                      Row(
                        children: [
                          // Inside the Row where the Explain button is located
                          OpenContainer(
                            transitionDuration: const Duration(milliseconds: 500),
                            openBuilder: (context, _) => ChangeNotifierProvider.value(
                              value: viewModel,
                              child: QOTDExplanationScreen(selectedOption: selectedOption),
                            ),
                            closedElevation: 0,
                            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            closedColor: Colors.transparent,
                            closedBuilder: (context, openContainer) => TextButton(
                              onPressed: hasAnswered ? openContainer : null,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              child: const Text(
                                'Explain',
                                style: TextStyle(
                                  color: Color(0xFF001F54),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
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

  // Updated method to handle option selection and correct/incorrect logic
  Widget _buildOptionCard(Option option, Question question) {
    final bool isSelected = selectedOption == option.prefix;
    final bool isCorrect = question.correctOption == option.prefix;
    final bool showResult = hasAnswered;
    
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
          onTap: hasAnswered ? null : () {
            setState(() {
              selectedOption = option.prefix;
              hasAnswered = true;
            });
          },
          borderRadius: BorderRadius.circular(12),
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
                if (showResult && isCorrect)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                if (showResult && isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: Colors.red, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}