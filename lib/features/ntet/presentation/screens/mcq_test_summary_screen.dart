import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mcq_test_view_model.dart';
import '../../../home/presentation/viewmodels/profile_view_model.dart';

class MCQTestSummaryScreen extends StatelessWidget {
  const MCQTestSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the MCQTestViewModel from the parent context
    final testViewModel = Provider.of<MCQTestViewModel>(context);
    
    // Use the existing ProfileViewModel
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: _MCQTestSummaryView(testViewModel: testViewModel),
    );
  }
}

class _MCQTestSummaryView extends StatefulWidget {
  final MCQTestViewModel testViewModel;
  
  const _MCQTestSummaryView({Key? key, required this.testViewModel}) : super(key: key);
  
  @override
  State<_MCQTestSummaryView> createState() => _MCQTestSummaryViewState();
}

class _MCQTestSummaryViewState extends State<_MCQTestSummaryView> {
  // Store the current question index when entering the summary screen
  late int _previousQuestionIndex;
  
  @override
  void initState() {
    super.initState();
    // Store the current question index
    _previousQuestionIndex = widget.testViewModel.currentQuestionIndex;
    
    // Load user profile when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        title: const Text(
          'Test Summary',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Return to the previous question when going back
            widget.testViewModel.navigateToQuestion(_previousQuestionIndex);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User name card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        profileViewModel.isLoading 
                            ? 'Loading...' 
                            : (profileViewModel.nameController.text.isNotEmpty 
                                ? profileViewModel.nameController.text 
                                : 'User'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Question status summary card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        context,
                        Colors.grey[300]!,
                        widget.testViewModel.getNotVisitedCount(),
                        'Not Visited',
                      ),
                      const SizedBox(height: 12),
                      _buildStatusRow(
                        context,
                        Colors.green,
                        widget.testViewModel.getAnsweredCount(),
                        'Answered',
                      ),
                      const SizedBox(height: 12),
                      _buildStatusRow(
                        context,
                        Colors.red,
                        widget.testViewModel.getNotAnsweredCount(),
                        'Not Answered',
                      ),
                      const SizedBox(height: 12),
                      _buildStatusRow(
                        context,
                        Colors.purple,
                        widget.testViewModel.getMarkedForReviewCount(),
                        'Marked for Review',
                      ),
                      const SizedBox(height: 12),
                      _buildStatusRow(
                        context,
                        Colors.purple,
                        widget.testViewModel.getAnsweredAndMarkedCount(),
                        'Answered & Marked for review\n(Will be considered for evolution)',
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Question number grid card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300, // Fixed height for the grid
                    child: GridView.builder(
                      // Enable vertical scrolling
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.testViewModel.test?.questions.length ?? 0,
                      itemBuilder: (context, index) {
                        return _buildQuestionNumberCard(context, index, widget.testViewModel);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusRow(
    BuildContext context,
    Color color,
    int count,
    String label,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color == Colors.grey[300] ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuestionNumberCard(BuildContext context, int index, MCQTestViewModel viewModel) {
    final questionStatus = viewModel.getQuestionStatus(index);
    Color backgroundColor;
    Color textColor;
    
    switch (questionStatus) {
      case QuestionStatus.notVisited:
        backgroundColor = Colors.grey[300]!;
        textColor = Colors.black;
        break;
      case QuestionStatus.answered:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case QuestionStatus.notAnswered:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case QuestionStatus.markedForReview:
        backgroundColor = Colors.purple;
        textColor = Colors.white;
        break;
      case QuestionStatus.answeredAndMarked:
        backgroundColor = Colors.purple;
        textColor = Colors.white;
        break;
    }
    
    return GestureDetector(
      onTap: () {
        widget.testViewModel.navigateToQuestion(index);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}