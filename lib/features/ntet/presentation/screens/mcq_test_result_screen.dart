import 'package:domus/features/ntet/domain/models/mcq_test_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mcq_test_view_model.dart';
import '../../../shared/widgets/blue_white_container.dart';
import '../viewmodels/user_view_model.dart';

class MCQTestResultScreen extends StatefulWidget {
  final MCQTest test;
  final List<int> selectedAnswers;
  final int totalTimeSpent;

  const MCQTestResultScreen({
    Key? key,
    required this.test,
    required this.selectedAnswers,
    required this.totalTimeSpent,
  }) : super(key: key);

  @override
  State<MCQTestResultScreen> createState() => _MCQTestResultScreenState();
}

class _MCQTestResultScreenState extends State<MCQTestResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _firstName = "Dr.Ankit";
  late int _rank = 65;
  
  // Calculated values
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  int _unansweredQuestions = 0;
  int _totalQuestions = 0;
  double _percentageScore = 0.0;
  String _formattedTime = "00:00";
  
  // Mock leaderboard data
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Dr.Ankit\'s', 'score': '00', 'rank': '!!'},
    {'name': 'Cody Fisher', 'score': '325', 'rank': '1'},
    {'name': 'Albert Flores', 'score': '300', 'rank': '2'},
    {'name': 'Robert Fox', 'score': '298', 'rank': '3'},
    {'name': 'Darrell Steward', 'score': '292', 'rank': '4'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    // Calculate results
    _calculateResults();
  }

  void _calculateResults() {
    // Remove the Provider.of call that was causing the error
    _totalQuestions = widget.test.questions.length;
    
    for (int i = 0; i < widget.selectedAnswers.length; i++) {
      if (widget.selectedAnswers[i] == -1) {
        _unansweredQuestions++;
      } else if (widget.selectedAnswers[i] == widget.test.questions[i].correctAnswer) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
      }
    }
    
    _percentageScore = (_correctAnswers / _totalQuestions) * 100;
    
    // Calculate formatted time from totalTimeSpent
    int minutes = widget.totalTimeSpent ~/ 60;
    int seconds = widget.totalTimeSpent % 60;
    _formattedTime = '${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}sec';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Mock Test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Restart test functionality
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF76B947),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
              child: const Text(
                'Reattempt',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _tabController.animateTo(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 0 
                              ? const Color(0xFF76B947) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 20,
                              color: _tabController.index == 0 ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Status',
                              style: TextStyle(
                                color: _tabController.index == 0 
                                    ? Colors.white 
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _tabController.animateTo(1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 1 
                              ? const Color(0xFF76B947) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 20,
                              color: _tabController.index == 1 ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Answer analysis',
                              style: TextStyle(
                                color: _tabController.index == 1 
                                    ? Colors.white 
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Performance Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
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
                        '$_firstName\'s Performance',
                        style: const TextStyle(
                          color: Color(0xFF76B947),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                      'Rank : $_rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStatusTab(),
                  _buildAnswerAnalysisTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Test Details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableRow('Mock paper name', ': HMM A Name Drug'),
                _buildTableRow('Attempt Number', ': 3rd Attempt'),
                _buildTableRow('Questions Attempt', ': 0/100'),
                _buildTableRow('Total Marks', ': 400'),
                _buildTableRow('Marking scheme', ': +4 -1'),
                _buildTableRow('Total time taken', ': $_formattedTime'),
                _buildTableRow('Start Time', ': 11:40:53PM'),
                _buildTableRow('End Time', ': 11:43:25PM'),
              ],
            ),
          ),
          
          // Percentage Status
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF76B947), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pie_chart,
                        color: Color(0xFF76B947),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Percentage Status',
                        style: TextStyle(
                          color: Color(0xFF76B947),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPercentageCircle(
                      'Correct',
                      (_correctAnswers / _totalQuestions) * 100,
                      Colors.green,
                    ),
                    _buildPercentageCircle(
                      'Incorrect',
                      (_incorrectAnswers / _totalQuestions) * 100,
                      Colors.red,
                    ),
                    _buildPercentageCircle(
                      'Unanswered',
                      (_unansweredQuestions / _totalQuestions) * 100,
                      Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Marks Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9747FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'MARKS OBTAINED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_correctAnswers * 4 - _incorrectAnswers} marks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF76B947),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'CORRECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_correctAnswers marks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'INCORRECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_incorrectAnswers marks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'UNANSWERED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_unansweredQuestions * 4} marks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Leaderboard
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFFFD700), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.leaderboard,
                        color: Color(0xFFFFD700),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Leaderboard',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        color: Color(0xFF333333),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Rank',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Score',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ..._leaderboard.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      Color rowColor;
                      
                      if (index == 0) {
                        rowColor = const Color(0xFFE0B0FF); // Purple for user
                      } else if (index == 1) {
                        rowColor = const Color(0xFFFFFF99); // Yellow for 1st
                      } else if (index == 2) {
                        rowColor = const Color(0xFFFFE5B4); // Peach for 2nd
                      } else if (index == 3) {
                        rowColor = const Color(0xFFFFDAB9); // Light peach for 3rd
                      } else {
                        rowColor = Colors.white; // White for others
                      }
                      
                      return TableRow(
                        decoration: BoxDecoration(
                          color: rowColor,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['rank'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['score'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnswerAnalysisTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.test.questions.length,
      itemBuilder: (context, index) {
        final question = widget.test.questions[index];
        final selectedAnswer = widget.selectedAnswers[index];
        final isCorrect = selectedAnswer == question.correctAnswer;
        final isUnanswered = selectedAnswer == -1;
        
        Color statusColor;
        String statusText;
        
        if (isUnanswered) {
          statusColor = Colors.blue;
          statusText = 'Unanswered';
        } else if (isCorrect) {
          statusColor = Colors.green;
          statusText = 'Correct';
        } else {
          statusColor = Colors.red;
          statusText = 'Incorrect';
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(question.options.length, (optionIndex) {
                  final option = question.options[optionIndex];
                  final isSelected = selectedAnswer == optionIndex;
                  final isCorrectOption = question.correctAnswer == optionIndex;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getOptionColor(isSelected, isCorrectOption),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + optionIndex), // A, B, C, D
                              style: TextStyle(
                                color: isSelected || isCorrectOption ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: _getOptionTextStyle(isSelected, isCorrectOption),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageCircle(String label, double percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getOptionColor(bool isSelected, bool isCorrectOption) {
    if (isCorrectOption) {
      return Colors.green;
    } else if (isSelected) {
      return Colors.red;
    } else {
      return Colors.grey.shade200;
    }
  }

  TextStyle _getOptionTextStyle(bool isSelected, bool isCorrectOption) {
    if (isCorrectOption) {
      return const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
    } else if (isSelected) {
      return const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
    } else {
      return const TextStyle(
        fontSize: 14,
      );
    }
  }
}