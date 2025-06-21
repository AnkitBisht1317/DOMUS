import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/qotd_explanation_screen.dart';
import '../viewmodels/question_view_model.dart';
import '../../domain/models/question_of_day.dart';
import 'package:animations/animations.dart';

class QuestionOfDaySection extends StatelessWidget {
  const QuestionOfDaySection({Key? key}) : super(key: key);

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
                    Text(
                      question.date,
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
                      
                      // Options
                      ...question.options.map((option) => _buildOptionCard(option)),
                      
                      const SizedBox(height: 16),
                      // Bottom buttons
                      Row(
                        children: [
                          // Replace the Explain button with this OpenContainer implementation
                          
                          // Inside the Row where the Explain button is located
                          OpenContainer(
                            transitionDuration: const Duration(milliseconds: 500),
                            openBuilder: (context, _) => ChangeNotifierProvider.value(
                              value: viewModel,
                              child: const QOTDExplanationScreen(),
                            ),
                            closedElevation: 0,
                            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            closedColor: Colors.transparent,
                            closedBuilder: (context, openContainer) => TextButton(
                              onPressed: openContainer,
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

  Widget _buildOptionCard(QuestionOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
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
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  '${option.prefix}.',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  option.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}