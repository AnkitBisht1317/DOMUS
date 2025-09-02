import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

import '../viewmodels/mcq_test_result_view_model.dart';

class AnswerAnalysisTabWidget extends StatefulWidget {
  final MCQTestResultViewModel viewModel;

  const AnswerAnalysisTabWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<AnswerAnalysisTabWidget> createState() =>
      _AnswerAnalysisTabWidgetState();
}

class _AnswerAnalysisTabWidgetState extends State<AnswerAnalysisTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Answer Key and Description tabs
        _buildTabButtons(),

        // Question cards in scrollable area
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  widget.viewModel.test.questions.length,
                  (index) => _buildQuestionCard(context, index),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SegmentedTabControl(
        tabTextColor: Colors.black87,
        selectedTabTextColor: Colors.white,
        squeezeIntensity: 2,
        height: 45,
        tabPadding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          SegmentTab(
            label: 'Answer Key',
            color: Color(0xFF76B947),
            backgroundColor: Colors.transparent,
          ),
          SegmentTab(
            label: 'Description',
            color: Color(0xFF76B947),
            backgroundColor: Colors.transparent,
          ),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, int questionIndex) {
    final question = widget.viewModel.test.questions[questionIndex];
    final selectedAnswer = widget.viewModel.selectedAnswers[questionIndex];
    final correctAnswer = question.correctAnswer;

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
            
            // Show explanation if Description tab is selected
            if (_selectedTabIndex == 1 && question.explanation != null && question.explanation!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explanation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF76B947),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.explanation!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
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

    // Text color based on whether it's correct
    Color textColor = Colors.black87;
    if (isCorrect) {
      textColor = const Color(0xFF76B947); // Green for correct answer
    }

    // Font weight based on whether it's correct
    FontWeight fontWeight = isCorrect ? FontWeight.bold : FontWeight.normal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ]),
    );
  }
}
