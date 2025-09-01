import 'package:flutter/material.dart';
import '../viewmodels/mcq_test_result_view_model.dart';

class PercentageCircleWidget extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const PercentageCircleWidget({
    Key? key,
    required this.label,
    required this.percentage,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class TableRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const TableRowWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// This class creates a TableRow for the leaderboard
class LeaderboardTableRow extends StatelessWidget {
  final String rank;
  final String name;
  final String score;
  final bool isUser;

  const LeaderboardTableRow({
    Key? key,
    required this.rank,
    required this.name,
    required this.score,
    this.isUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
      color: isUser ? Colors.blue : Colors.black,
    );
    
    // Wrap TableRow in a Container to return a Widget
    return Container(
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        border: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              rank,
              style: textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              name,
              style: textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              score,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceCircle extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final bool isRank;

  const PerformanceCircle({
    Key? key,
    required this.value,
    required this.label,
    required this.color,
    this.isRank = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: color,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  isRank ? '#$value' : '$value%',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const StatColumn({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001F54),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class QuestionOptionWidget extends StatelessWidget {
  final int questionIndex;
  final int optionIndex;
  final String optionText;
  final MCQTestResultViewModel viewModel;

  const QuestionOptionWidget({
    Key? key,
    required this.questionIndex,
    required this.optionIndex,
    required this.optionText,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: viewModel.getOptionColor(questionIndex, optionIndex),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: viewModel.selectedAnswers[questionIndex] == optionIndex 
                  ? (optionIndex == viewModel.test.questions[questionIndex].correctAnswer ? const Color(0xFF76B947) : Colors.red) 
                  : (optionIndex == viewModel.test.questions[questionIndex].correctAnswer ? const Color(0xFF76B947) : Colors.white),
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
            child: Center(
              child: Text(
                String.fromCharCode(65 + optionIndex),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: viewModel.selectedAnswers[questionIndex] == optionIndex || optionIndex == viewModel.test.questions[questionIndex].correctAnswer
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              optionText,
              style: viewModel.getOptionTextStyle(questionIndex, optionIndex),
            ),
          ),
        ],
      ),
    );
  }
}