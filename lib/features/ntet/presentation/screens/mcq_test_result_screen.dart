import 'package:domus/features/ntet/domain/models/mcq_test_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import '../viewmodels/mcq_test_result_view_model.dart';
import '../widgets/mcq_result_tabs.dart';
import '../../../shared/widgets/blue_white_container.dart';

class MCQTestResultScreen extends StatefulWidget {
  final MCQTest test;
  final List<int> selectedAnswers;
  final int totalTimeSpent;
  final DateTime? startTime;
  final DateTime? endTime;
  final int attemptCount;

  const MCQTestResultScreen({
    Key? key,
    required this.test,
    required this.selectedAnswers,
    required this.totalTimeSpent,
    this.startTime,
    this.endTime,
    this.attemptCount = 0,
  }) : super(key: key);

  @override
  State<MCQTestResultScreen> createState() => _MCQTestResultScreenState();
}

class _MCQTestResultScreenState extends State<MCQTestResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MCQTestResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    // Initialize the view model
    _viewModel = MCQTestResultViewModel(
      test: widget.test,
      selectedAnswers: widget.selectedAnswers,
      totalTimeSpent: widget.totalTimeSpent,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFF001F54),
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              // Main content with white container
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
                      _buildTabBar(),
                      _buildTabView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Calculate available width for title
    final screenWidth = MediaQuery.of(context).size.width;
    final leadingWidth = 40.0; // Approximate width of back button
    final actionWidth = 100.0; // Approximate width of reattempt button
    final availableTitleWidth = screenWidth - leadingWidth - actionWidth - 32; // 32 for padding
    
    return AppBar(
      backgroundColor: const Color(0xFF001F54),
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Container(
        width: availableTitleWidth,
        child: Text(
          widget.test.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
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
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SegmentedTabControl(
        // Customization of widget
        // backgroundColor: Colors.white,
        // indicatorColor: const Color(0xFF76B947),
        tabTextColor: Colors.black,
        selectedTabTextColor: Colors.white,
        squeezeIntensity: 2,
        tabPadding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        // Tabs
        tabs: [
          SegmentTab(
            label: 'Status',
            splashColor: Color(0xFF204770),
            backgroundColor: Colors.white,
            color: const Color(0xFF76B947),

          ),
          SegmentTab(
            label: 'Answer analysis',
            splashColor: Color(0xFF204770),
            backgroundColor: Colors.white,
            color: const Color(0xFF76B947),
          ),
        ],
        controller: _tabController,
      ),
    );
  }
  
  Widget _buildPerformanceHeader() {
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
      child: Consumer<MCQTestResultViewModel>(
        builder: (context, viewModel, _) => Row(
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
                  '${viewModel.userName}\'s Performance',
                  style: const TextStyle(
                    color: Color(0xFF76B947),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
      ),
    );
  }
  
  Widget _buildTabView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TabBarView(
          controller: _tabController,
          children: [
            Consumer<MCQTestResultViewModel>(
              builder: (context, viewModel, _) => StatusTabWidget(viewModel: viewModel),
            ),
            Consumer<MCQTestResultViewModel>(
              builder: (context, viewModel, _) => AnswerAnalysisTabWidget(viewModel: viewModel),
            ),
          ],
        ),
      ),
    );
  }




}