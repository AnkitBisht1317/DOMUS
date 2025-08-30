import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mcq_test_view_model.dart';
import '../../di/mcq_test_injection.dart';
import 'mcq_test_summary_screen.dart';

class MCQTestScreen extends StatefulWidget {
  final String title;

  const MCQTestScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MCQTestScreen> createState() => _MCQTestScreenState();
}

class _MCQTestScreenState extends State<MCQTestScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MCQTestInjection.providers,
      child: _MCQTestView(title: widget.title),
    );
  }
}

class _MCQTestView extends StatefulWidget {
  final String title;

  const _MCQTestView({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<_MCQTestView> createState() => _MCQTestViewState();
}

class _MCQTestViewState extends State<_MCQTestView> {
  late MCQTestViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    // Get the view model from the provider
    viewModel = Provider.of<MCQTestViewModel>(context, listen: false);
    // Load the test data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadTest(widget.title);
    });
  }
  
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Test?'),
        content: const Text('Are you sure you want to exit the test? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF001F54),
        body: SafeArea(
          child: Consumer<MCQTestViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              
              if (viewModel.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${viewModel.error}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.loadTest(widget.title);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                children: [
                  // Top header with title and submit button
                  _buildHeader(context, viewModel),
                  
                  // Main content area
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
                      child: Column(
                        children: [
                          // Question number and timer
                          _buildControlsBar(viewModel),
                          
                          // Question content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Question text
                                  if (viewModel.currentQuestion != null) ...[
                                    Text(
                                      viewModel.currentQuestion!.question,
                                      style: TextStyle(
                                        fontSize: viewModel.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Options
                                    ...List.generate(
                                      viewModel.currentQuestion!.options.length,
                                      (index) => _buildOptionItem(
                                        context,
                                        index,
                                        viewModel.currentQuestion!.options[index],
                                        viewModel.selectedAnswerIndex == index,
                                        viewModel,
                                      ),
                                    ),
                                  ] else ...[
                                    const Center(
                                      child: Text(
                                        "Loading question...",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          
                          // Navigation buttons
                          _buildNavigationBar(viewModel),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, MCQTestViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _onWillPop().then((value) {
                if (value) {
                  Navigator.of(context).pop();
                }
              });
            },
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Navigate to summary screen with the viewModel
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: viewModel,
                    child: const MCQTestSummaryScreen(),
                  ),
                ),
              );
            },
            padding: EdgeInsets.zero,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF94B449),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Submit test and navigate to result screen
              viewModel.submitTest(context);
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlsBar(MCQTestViewModel viewModel) {
    // Add null check to prevent null pointer exception
    if (viewModel.test == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text("Loading test data...", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Question number
          Text(
            'Question ${viewModel.currentQuestionIndex + 1}/${viewModel.test?.questions.length ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          
          // Timer
          Row(
            children: [
              const Icon(Icons.timer, size: 20),
              const SizedBox(width: 4),
              Text(
                viewModel.formatTime(viewModel.remainingTime),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          // Time spent on current question
          Row(
            children: [
              const Icon(Icons.hourglass_bottom, size: 20),
              const SizedBox(width: 4),
              Text(
                '${viewModel.timeSpent[viewModel.currentQuestionIndex].toString().padLeft(2, '0')} s',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildOptionItem(
    BuildContext context,
    int index,
    String option,
    bool isSelected,
    MCQTestViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () {
        viewModel.selectAnswer(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF001F54) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF001F54) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : const Color(0xFF001F54),
                border: Border.all(
                  color: const Color(0xFF001F54),
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D...
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF001F54) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: viewModel.fontSize - 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavigationBar(MCQTestViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Font size controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: viewModel.decreaseFontSize,
              ),
              const Text('Font'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: viewModel.increaseFontSize,
              ),
            ],
          ),
          
          // Navigation buttons
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: viewModel.currentQuestionIndex > 0
                    ? viewModel.previousQuestion
                    : null,
                child: const Text(
                  'Previous',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: viewModel.currentQuestionIndex < (viewModel.test?.questions.length ?? 0) - 1
                    ? viewModel.nextQuestion
                    : null,
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
