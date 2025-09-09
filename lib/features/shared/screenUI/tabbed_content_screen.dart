import 'package:flutter/material.dart';
import '../widgets/tabbed_content_container.dart';
import '../widgets/content_list_view.dart';
import '../widgets/lecture_detail_header.dart';
import '../widgets/lecture_action_buttons.dart';
import '../widgets/blue_white_container.dart';
import '../widgets/content_item_card.dart';
import 'lecture_player_screen.dart';
import 'pdf_viewer_screen.dart';
import '../../ntet/presentation/widgets/purchase_dialog.dart';

/// An example screen that demonstrates how to use the shared UI components
class TabbedContentScreen extends StatefulWidget {
  final String title;
  final String? subtitle;

  const TabbedContentScreen({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  State<TabbedContentScreen> createState() => _TabbedContentScreenState();
}

class _TabbedContentScreenState extends State<TabbedContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Example data for lectures
  final List<Map<String, dynamic>> lectures = List.generate(10, (index) {
    String subject = index < 4 ? 'Physics' : (index < 7 ? 'Chemistry' : 'Biology');
    int chapterNum = (index % 3) + 1;
    int lectureNum = (index % 3) + 1;
    
    return {
      'title': '$subject Chapter $chapterNum || Lecture $lectureNum',
      'subtitle': 'Introduction to $subject',
      'source': 'from NEET Batch',
      'imageUrl': 'assets/physics.png',
      'isUnlocked': index < 3, // Only first 3 lectures are unlocked
      'duration': '1:15:59',
      'progress': 0.1 + (index % 7) * 0.1,
    };
  });
  
  // Example data for notes
  final List<Map<String, dynamic>> notes = List.generate(10, (index) {
    String subject = index < 4 ? 'Physics' : (index < 7 ? 'Chemistry' : 'Biology');
    int chapterNum = index + 1;
    
    return {
      'title': '$subject Notes Chapter $chapterNum',
      'subtitle': 'Complete Study Material',
      'source': 'from NEET Batch',
      'imageUrl': 'assets/books.png', // Using books.png as icon
      'isUnlocked': index < 3, // Only first 3 notes are unlocked
    };
  });
  
  // Example data for MCQs
  final List<Map<String, dynamic>> mcqs = List.generate(10, (index) {
    String subject = index < 4 ? 'Physics' : (index < 7 ? 'Chemistry' : 'Biology');
    
    return {
      'title': '$subject MCQs Set ${index + 1}',
      'subtitle': '50 Questions with Solutions',
      'source': 'from NEET Batch',
      'imageUrl': 'assets/test.png', // Using test.png as icon
      'isUnlocked': index < 3, // Only first 3 MCQs are unlocked
    };
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F54),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content with white container and rounded corners
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
                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabButton(0, 'Lecture'),
                          _buildTabButton(1, 'Notes'),
                          _buildTabButton(2, 'MCQs'),
                        ],
                      ),
                    ),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(), // Disable swiping
                        children: [
                          // Lecture Tab Content
                          _buildLectureTabContent(),
                          
                          // Notes Tab Content
                          _buildNotesTabContent(),
                          
                          // MCQs Tab Content
                          _buildMCQsTabContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    bool isSelected = _tabController.index == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.index = index; // Direct index change without animation
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF001F54) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF001F54),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLectureTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        
        return ContentItemCard(
          title: lecture['title'],
          subtitle: lecture['subtitle'],
          source: lecture['source'],
          imageUrl: lecture['imageUrl'],
          duration: lecture['duration'],
          progress: lecture['progress'],
          isLocked: !lecture['isUnlocked'],
          onTap: () {
            if (lecture['isUnlocked']) {
              _showLectureDetail(context, lecture['title'], lecture['source']);
            } else {
              PurchaseDialog.show(context);
            }
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${lecture['title']}')),
            );
          },
        );
      },
    );
  }
  
  Widget _buildNotesTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        
        return ContentItemCard(
          title: note['title'],
          subtitle: note['subtitle'],
          source: note['source'],
          imageUrl: note['imageUrl'],
          isLocked: !note['isUnlocked'],
          onTap: () {
            if (note['isUnlocked']) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(
                    title: note['title'],
                    pdfPath: 'assets/sample.pdf',
                  ),
                ),
              );
            } else {
              PurchaseDialog.show(context);
            }
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${note['title']}')),
            );
          },
        );
      },
    );
  }
  
  Widget _buildMCQsTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: mcqs.length,
      itemBuilder: (context, index) {
        final mcq = mcqs[index];
        
        return ContentItemCard(
          title: mcq['title'],
          subtitle: mcq['subtitle'],
          source: mcq['source'],
          imageUrl: mcq['imageUrl'],
          isLocked: !mcq['isUnlocked'],
          onTap: () {
            if (mcq['isUnlocked']) {
              // Navigate to MCQ test screen instead of PDF viewer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening MCQ test...')),
              );
              // You can implement a proper MCQ test screen navigation here
            } else {
              PurchaseDialog.show(context);
            }
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${mcq['title']}')),
            );
          },
        );
      },
    );
  }
  
  void _showLectureDetail(BuildContext context, String title, String source) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LecturePlayerScreen(
          title: title,
          batchName: source,
          duration: '1:15:59', // Example duration
          progress: 0.3, // Example progress
        ),
      ),
    );
  }
}