import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mcq_test_result_view_model.dart';
import 'mcq_result_widgets.dart';

class StatusTabWidget extends StatelessWidget {
  final MCQTestResultViewModel viewModel;

  const StatusTabWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  // Helper method for ordinal numbers (1st, 2nd, 3rd, etc.)
  String _getOrdinal(int number) {
    // Ensure number is at least 1 (no 0th attempt)
    int displayNumber = number < 1 ? 1 : number;
    
    if (displayNumber == 1) {
      return '1st';
    } else if (displayNumber == 2) {
      return '2nd';
    } else if (displayNumber == 3) {
      return '3rd';
    } else {
      return '${displayNumber}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserPerformanceHeader(context),
          _buildPerformanceStats(context),
          const SizedBox(height: 20),
          _buildLeaderboard(context),
        ],
      ),
    );
  }
  
  // Performance header that will now be part of the scrollable content
  Widget _buildUserPerformanceHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'DR.${viewModel.userName}\'s Performance',
                style: const TextStyle(
                  color: Color(0xFF76B947),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF76B947),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Rank : ${viewModel.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],

      ),
    );
  }

  Widget _buildPerformanceStats(BuildContext context) {
    final viewModel = Provider.of<MCQTestResultViewModel>(context);
    
    // Format times using the actual recorded start and end times
    final startTimeFormatted = '${viewModel.startTime.hour % 12 == 0 ? 12 : viewModel.startTime.hour % 12}:${viewModel.startTime.minute.toString().padLeft(2, '0')}:${viewModel.startTime.second.toString().padLeft(2, '0')}${viewModel.startTime.hour >= 12 ? 'PM' : 'AM'}';
    final endTimeFormatted = '${viewModel.endTime.hour % 12 == 0 ? 12 : viewModel.endTime.hour % 12}:${viewModel.endTime.minute.toString().padLeft(2, '0')}:${viewModel.endTime.second.toString().padLeft(2, '0')}${viewModel.endTime.hour >= 12 ? 'PM' : 'AM'}';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Detailed information section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Mock paper name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': ${viewModel.test.title}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Attempt Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': ${_getOrdinal(viewModel.attemptNumber)} Attempt',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Questions Attempt',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': ${viewModel.correctAnswers + viewModel.incorrectAnswers}/${viewModel.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Total Marks',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': ${viewModel.totalMarks}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Marking scheme',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        const Text(
                          ': ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.green,
                          child: const Center(
                            child: Text(
                              '+4',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.red,
                          child: const Center(
                            child: Text(
                              '-1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Total time taken',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': ${viewModel.formattedTime}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Start Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': $startTimeFormatted',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'End Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ': $endTimeFormatted',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Percentage Status section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pie_chart, color: Colors.green.shade700, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Percentage Status',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPercentageCircle(
                      '${viewModel.percentageScore.toInt()}%',
                      'Correct',
                      Colors.blue,
                    ),
                    _buildPercentageCircle(
                      '${(100 - viewModel.percentageScore).toInt()}%',
                      'Incorrect',
                      Colors.grey,
                    ),
                    _buildPercentageCircle(
                      '${viewModel.unansweredQuestions * 100 ~/ viewModel.totalQuestions}%',
                      'Unanswered',
                      Colors.purple,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.pink.shade100,
                        child: Center(
                          child: Text(
                            'MARKS OBTAINED\n${viewModel.marksObtained} marks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.pink.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.green.shade100,
                        child: Center(
                          child: Text(
                            'CORRECT\n${viewModel.correctAnswers} marks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.red.shade100,
                        child: Center(
                          child: Text(
                            'INCORRECT\n${viewModel.incorrectAnswers} marks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.yellow.shade100,
                        child: Center(
                          child: Text(
                            'UNANSWERED\n${viewModel.unansweredQuestions} marks',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPercentageCircle(String percentage, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              percentage,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...viewModel.leaderboard.asMap().entries.map((entry) {
                  final index = entry.key;
                  final user = entry.value;
                  final isUser = user['name'] == viewModel.userName;
                  
                  // Background colors for different ranks
                  Color? bgColor;
                  if (isUser) {
                    bgColor = Colors.purple.shade100;
                  } else if (index == 0) {
                    bgColor = Colors.yellow.shade100;
                  } else if (index == 1) {
                    bgColor = Colors.yellow.shade50;
                  } else if (index == 2) {
                    bgColor = Colors.orange.shade50;
                  }
                  
                  return TableRow(
                    decoration: BoxDecoration(
                      color: bgColor ?? Colors.transparent,
                      border: const Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: isUser || index == 0 ? FontWeight.bold : FontWeight.normal,
                            color: isUser ? Colors.purple : (index == 0 ? Colors.amber.shade700 : Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          user['name'] as String,
                          style: TextStyle(
                            fontWeight: isUser || index == 0 ? FontWeight.bold : FontWeight.normal,
                            color: isUser ? Colors.purple : (index == 0 ? Colors.amber.shade700 : Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                         padding: const EdgeInsets.symmetric(vertical: 12.0),
                         child: Text(
                           '${user['score']}',
                           style: TextStyle(
                             fontWeight: isUser || index == 0 ? FontWeight.bold : FontWeight.normal,
                             color: isUser ? Colors.purple : (index == 0 ? Colors.amber.shade700 : Colors.black),
                           ),
                         ),
                       ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerAnalysisTabWidget extends StatelessWidget {
  final MCQTestResultViewModel viewModel;

  const AnswerAnalysisTabWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Answer Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F54),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTableHeader(),
                const SizedBox(height: 8),
                ...List.generate(
                  viewModel.test.questions.length,
                  (index) => _buildQuestionItem(context, index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF001F54),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'Q',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Question & Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem(BuildContext context, int index) {
    final question = viewModel.test.questions[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF001F54).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF001F54),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF001F54),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      question.options.length,
                      (optionIndex) => QuestionOptionWidget(
                        questionIndex: index,
                        optionIndex: optionIndex,
                        optionText: question.options[optionIndex],
                        viewModel: viewModel,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}