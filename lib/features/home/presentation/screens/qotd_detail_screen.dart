import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/question_view_model.dart';
import '../widgets/qotd_question_item.dart';

class QOTDDetailScreen extends StatelessWidget {
  const QOTDDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F54),
      body: Column(
        children: [
          // Top container with QOTD title and back button only
          Container(
            width: double.infinity,
            color: const Color(0xFF001F54),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                const Text(
                  'QOTD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Content container with rounded top corners
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
                  // Filter button positioned above the scrollable row
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.filter_list, size: 20, color: Color(0xFF001F54)),
                          const SizedBox(width: 4),
                          const Text(
                            'Filter',
                            style: TextStyle(
                              color: Color(0xFF001F54),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Filter buttons section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterButton('Ques of Day', true),
                          const SizedBox(width: 12),
                          _buildFilterButton('Clinical Case', false),
                          const SizedBox(width: 12),
                          _buildFilterButton('Opinion Poll', false),
                        ],
                      ),
                    ),
                  ),
                  
                  // Questions list
                  Expanded(
                    child: Consumer<QuestionViewModel>(builder: (context, viewModel, _) {
                      final question = viewModel.questionOfDay;
                      if (question == null) return const Center(child: Text('No questions available'));
                      
                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          QOTDQuestionItem(
                            question: question,
                            logoAsset: 'assets/books.png',
                            date: '04 May 2025',
                          ),
                          QOTDQuestionItem(
                            question: question,
                            logoAsset: 'assets/books.png',
                            date: '04 May 2025',
                          ),
                          QOTDQuestionItem(
                            question: question,
                            logoAsset: 'assets/books.png',
                            date: '04 May 2025',
                          ),
                          QOTDQuestionItem(
                            question: question,
                            logoAsset: 'assets/books.png',
                            date: '04 May 2025',
                          ),
                          QOTDQuestionItem(
                            question: question,
                            logoAsset: 'assets/books.png',
                            date: '04 May 2025',
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF001F54) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF001F54),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF001F54),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}